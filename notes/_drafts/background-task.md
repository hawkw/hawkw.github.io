---
layout: post
title:  "Rust Async Pattern: Background Tasks"
categories: rust,programming
author: eliza
---

As part of recent work on [Conduit], I recently had the pleasure of getting to make several contributions to the excellent [Trust-DNS] library, maintained by Benjamin Frye ([@bluejekyll]). During a conversation with Ben on one of my pull requests, it came to light that several of the asynchronous programming patterns that my colleagues and I at [Buoyant] have found very useful in our Rust projects are not exactly common knowledge. Given that, I wanted to take a moment or two to write about some of these patterns and share them with the Rust community at large.

# Background Tasks

Often, when writing network applications, it is desirable for some state to be reused for certain actions, rather than set up repeatedly every time an action is carried out. For example, in an application that makes multiple HTTP requests to the same servers, we might want to store the underlying TCP connections used to make those requests in a _connection pool_, rather than creating a new connection for every request; or we might want to take some action based on state that is updated by certain events, such as a watch on a long-polling API.

One way to achieve this kind of pattern using Rust's [`tokio`] and [`futures`] libraries for asynchronous programming is to create what I've taken to referring to as _background tasks_. These background tasks are `Future`s which, once spawned on an `Executor`, continue to run on that `Executor` for a long period of time. Rather than running once and completing with some value, the background task instead 'wakes up' to perform some work to complete other `Future`s. The [`futures::sync::mpsc`] and [`futures::sync::oneshot`] modules in [`futures`] provide some primitives which make it remarkably easy to write this kind of future.

## A Contrived Example

To illustrate how this pattern works, let's start by considering a contrived example. Suppose we wanted to run a background task that receives requests to add pairs of numbers and return the sum (setting aside, for a moment, that this is almost certainly a misuse of the pattern).

We start by defining the type for the request we'll send to the background task:

```rust
use futures::sync::oneshot;

// A sum request consists of:
struct SumRequest {
    // Two numbers to add together...
    a: usize,
    b: usize,
    // ...and a `oneshot::Sender` for returning the sum.
    result_tx: oneshot::Sender<usize>,
}

```

Now we can define the background future itself, and the handle type we'll use for requesting it to do some work:
```rust
use futures::sync::mpsc;

/// A background task that handles `SumRequest`s.
pub struct SumBackground {
    rx: mpsc::UnboundedReceiver<SumRequest>,
}

/// A handle for communicating with a `SumTask`.
#[derive(Clone)]
pub struct SumHandle {
    tx: mpsc::UnboundedSender<SumRequest>,
}
```

The background task and handle communicate on an unbounded MPSC (multiple-producer, single-consumer) channel. The handle holds an `UnboundedSender` to send requests on the channel, while the background task holds the receive end of that channel.

### The Handle

To use our `SumHandle` to request that the background task sum two numbers, we create the send and receive sides of a `oneshot` channel. This will be used to send the result of the background computation back to the requester. Then, construct a `SumRequest` with the two numbers to add and and the `Sender` side of that channel, and then send the request over the unbounded `mpsc` channel between our handle and the background task. We return the `Receiver` end of the `oneshot` channel, which is the `Future` that will return the result of the background work to the caller.

```rust
impl SumHandle {
    /// Add two numbers `a` and `b` in the background and return the sum.
    pub fn sum(&mut self, a: usize, b: usize) -> impl Future<Item = usize, Error = ()> {
        // Construct a new oneshot channel on which we'll receive the result.
        let (result_tx, result_rx) = oneshot::channel();
        // Build  the request to send to the background task.
        let request = SumRequest {
            a,
            b,
            result_tx,
        };
        // Send the request.
        self.tx.unbounded_send(request)
            .expect("sending request to background task failed!");
        // Return the receive side of the oneshot channel, which is a
        //`Future<Item = usize>`.
        result_rx
            // The receiver should _not_ be dropped while there are
            // still `SumHandle`s.
            .map_err(|e| panic!("background task cancelled unexpectedly!"))
    }
}
```

If this were production code, we might want better error handling here, but I've used `expect` and `panic!` to keep the example simple.

### The Backround Future

Now, we can implement `Future` for the `SumBackground` struct. The `Future` implementation for a background task is typically fairly simple:
poll the receive side of the request channel and respond to each incoming request. We continue polling as long as there are more requests. If polling the request channel returns `Async::NotReady`, that means there are currently no more requests coming in, so we yield until we are polled again. If the request stream has ended (i.e., polling the channel returns `Async::Ready(None)`), this indicates that all the request handles have been dropped, in which case the background task can finish.

```rust
use futures::{Async, Future, Poll, Stream};

impl Future for SumBackground {
    // In order to be `spawn`ed in the background, the `Item` and
    // `Error` types of the future *must* be unit.
    type Item = ();
    type Error = ();

    fn poll(&mut self) -> Poll<(), ()> {
        // We'll use a loop to continue polling `rx` until it's  `NotReady`.
        loop {
            match self.rx.poll() {
                // When `rx` is `NotReady`, this means there are no more
                // incoming requests, so the background task should yield
                // until there are.
                Ok(Async::NotReady) => return Ok(Async::NotReady),
                // If the request stream has ended, then there are no more
                // handles, and the background task can complete successfully.
                Ok(Async::Ready(None)) => {
                    debug!("Request handles are gone; ending background task.");
                    return Ok(Async::Ready(()));
                },
                // We've gotten a request!
                Ok(Async::Ready(Some(SumRequest { a, b, result_tx }))) => {
                    // Sum the two numbers (this is where a more complex
                    // background task might compose a new `Future` to return).
                    let sum = a + b;
                    // Send the result on the oneshot channel included with the
                    // request.
                    if let Err(_) = result_tx.send(sum) {
                        // `oneshot::send` fails if the receiver was dropped,
                        // which is fine, so rather than panicking, just log
                        // that the request was canceled.
                        // (a more complex background task might clean up some
                        // state here...)
                        debug!("request canceled before it was completed");
                    }
                    // Don't return anything, just continue looping until
                    // there are no more incoming requests.
                }
                Err(e) => {
                    // The unbounded receiver should not error.
                    warn!("Request channel error: {:?}", e);
                    return Err(());
                }
            }
        }
    }
}
```

Finally, we can write a quick constructor for the background task:

```rust
impl SumBackground {
    pub fn new() -> (SumHandle, Self) {
        // Create an unbounded MPSC channel to communicate with the background
        // future.
        let (tx, rx) = mpsc::unbounded();

        // Build the background future and handle.
        let background = SumBackground { rx };
        let handle = SumHandle { tx };

        (handle, background)
    }
}
```

### Using It

To use our background task, we can construct a new background task and handle using `SumBackground::new()`. The `Future`s returned by `SumHandle::sum()` will not complete until the background future has been spawned on an executor, so we create one as well.

```rust
// Construct a background task and a handle.
let (mut handle, bg) = background_task_example::SumBackground::new();

// Create a new Tokio `Runtime` to execute our futures.
let mut rt = tokio::runtime::current_thread::Runtime::new()
    .unwrap();

// Spawn the background task on the runtime. It won't do anything
// until we make requests to it.
rt.spawn(bg);
```

Now, we can sum some numbers!

```rust
for i in 1..5 {
    println!("Adding 2 to {:?} in the background...", i);

    // Send the request to the background task, returning a future.
    let sum_future = handle.sum(i, 2);

    // Execute the future on the runtime to get the result.
    let sum = rt.block_on(sum_future).expect("summing should not fail!");

    println!("{:?} + 2 = {:?}", i, sum);
}
```

Note that because we used a multiple-producer, single-consumer channel for sending requests to the background task, the handle implements `Clone`; we can make as many instances of it as we like, and they will all send requests to the same background task we've constructed. Similarly, since both `mpsc::UnboundedSender` and `mpsc::UnboundedReceiver` implement `Send`, we're also free to move both the handle(s) and the background future itself into another thread.

For anyone interested in examples of more complex uses, I've put this example code, modified with more logging to show what's going on behind the scenes, [in a GitHub repo](https://github.com/hawkw/background-task-example) as well. This repo also contains runnable examples of more complex uses.


## In Real Life

That example was all well and good, but adding two numbers isn't exactly the kind of work we might want to execute in the background (it's almost certainly faster to just do it synchronously wherever the result is needed). Where might we actually expect to use this pattern in a real project, and what does that look like?

As an example, let's take a look at some code I wrote for a recent pull request, [bluejekyll/trust-dns#487]. This PR changes one of the core types in [Trust-DNS]' `trust-dns-resolver` library, formerly called `ResolverFuture`, to use a background task.

Trust-DNS' `ResolverFuture` provides methods to make various types of lookup requests to DNS servers asynchronously, returning `Future`s whose `Item`s are the appropriate DNS record. It is a `Future` itself, as before requests could be made, it is necessary to construct state, such as a [`NameServerPool`] which tracks statistics associated with multiple DNS name servers and load balances requests across them. In order for the name server pool to be used the most effectively, we would want to ensure that all the lookups an application that uses the resolver go through the same pool. However, we might also wish to be able to make DNS lookups from different places in our code, including from futures running on different `Executor`s or across threads. The previous implementation of the resolver as a single future made it difficult to satisfy both of these requirements, as Ben describes in [this issue]. In [Conduit], we make DNS queries using Trust-DNS's resolver, but we [had not been able to use the resolver efficiently](https://github.com/runconduit/conduit/issues/859) for these reasons.

As I mentioned earlier, managing a pooled resource is an excellent use case for the background task pattern, so when I saw that issue on Trust-DNS' GitHub issue tracker, I immediately thought of the background task pattern.

## The Big Picture

For readers who have more experience programming with Rust's futures than I do, this might be fairly obvious, but to me, this is the big realization behind this pattern. We usually think of a `Future` as 'a type  epresenting the eventual return value of an asynchronous computation', and often, this is how they are used. In many other languages with a similar construct, this is often all a `Future` is. But, due to [the polling-driven design of Rust's `Future`s](https://aturon.github.io/blog/2016/09/07/futures-design/), our `Future`s are more general: in essence, I like to think of them as 'a primitive for modelling cooperative multitasking'.

Finally, we should take a moment to note that I did not invent any of this. The concept of background work in general is, of course, not a new one at all; it certainly predates the Rust language and probably predates _me_ as well. Furthermore, I didn't originate this particular pattern for implementing background work using Rust's channels and futures, either. I'm not sure who did, but I'd hazard a guess that credit is probably due to [Aaron Turon], [Alex Crichton], [Carl Lerche], or one of the other pioneers of Rust async programming --- if anyone has a theory regarding where this specific way of implementing background work first appeared, I'd be interested to hear it. The primary role I've played in the story of this particular pattern is writing it down, and I haven't done _that_ alone, either. I'd like to thank Ben Frye ([@bluejekyll]) for the conversations that made me realize it might be valuable to write about this; and my partner Tristan, Camilla (@lobotomyp0p), and everyone else who proofread the post before it went up.


[Conduit]: https://runconduit.io
[Trust-DNS]: https://github.com/bluejekyll/trust-dns
[Buoyant]: https://buoyant.io
[@bluejekyll]: https://bluejekyll.github.io/
[`tokio`]: https://tokio.rs
[`futures`]: https://docs.rs/crate/futures/0.1.21
[`futures::sync::mpsc`]: https://docs.rs/futures/0.1.21/futures/sync/mpsc/index.html
[`futures::sync::oneshot`]: https://docs.rs/futures/0.1.21/futures/sync/oneshot/index.html
[bluejekyll/trust-dns#487]: https://github.com/bluejekyll/trust-dns/pull/487
[`NameServerPool`]: https://bluejekyll.github.io/blog/rust/2017/06/30/trust-dns-resolver.html#nameserverpool
[this issue]: https://github.com/bluejekyll/trust-dns/issues/464
[Aaron Turon]: http://aturon.github.io/
[Alex Crichton]: https://github.com/alexcrichton
[Carl Lerche]: https://github.com/carllerche


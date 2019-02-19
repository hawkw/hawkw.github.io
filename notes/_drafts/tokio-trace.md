---
layout: post
title:  "tokio-trace"
categories: rust,programming
author: eliza
---

For the last few months, I've had the pleasure of getting to work on
implementing
[`tokio-trace`](https://github.com/tokio-rs/tokio/tree/master/tokio-trace), a
scoped, structured, and async-aware logging and diagnostics framework for Rust.

## Why do we need another logging library?

Rust already has a robust logging ecosystem based around the
[`log`](https://github.com/rust-lang-nursery/log) crate's logging facade ---
there's `env-logger`, `fern`, and several other libraries to choose from. So why
is `tokio-trace` necessary, and what benefit does it provide that these existing
libraries don't?

To understand the primary motivation behind `tokio-trace`, we need to consider
the difficulties around instrumenting _asynchronous_ systems.

In synchronous code, we can simply log individual messages as we flow through
our program, and expect them to be printed out in order. A programmer can
interpret the logs fairly easily, since the log records are output
sequentially.

In asynchronous systems like Tokio, however, interpreting traditional log
messages can often be quite challenging. Since individual tasks are multiplexed
on the same thread, associated events and log lines are intermixed, making it difficult to trace the logic flow.

As an example, let's consider this example from the `log`
crate's documentation:

```rust
pub fn shave_the_yak(yak: &mut Yak) {
    trace!("Commencing yak shaving");

    loop {
        match find_a_razor() {
            Ok(razor) => {
                info!("Razor located: {}", razor);
                yak.shave(razor);
                break;
            }
            Err(err) => {
                warn!("Unable to locate a razor: {}, retrying", err);
            }
        }
    }
}
```

If we were to run this synchronous yak-shaving function, we might see output
like this:

```
TRACE yaklib::shaving: Commencing yak shaving
 WARN yaklib::shaving: Unable to locate a razor: all razors are in use, retrying
 WARN yaklib::shaving: Unable to locate a razor: all razors are in use, retrying
 WARN yaklib::shaving: Unable to locate a razor: all razors are in use, retrying
 INFO yaklib::shaving: Razor located: razor #6
DEBUG yaklib::yak: shaving yak "George" with razor #6
...
```

It's fairly easy to interpret these logs: the `shave_the_yak` function was
called, outputting the first log line. We had to retry the `find_a_razor`
function three times, but on the fourth attempt, razor #6 was found. The final
log line was presumably logged by the `Yak::shave` method.

Now suppose we have an asynchronous yak-shave implementation, represented as a
future.

```rust
struct ShaveYak {
    yak: Yak,
    state: YakShaveState,
}

struct YakShaveState {
    Start,
    FindingRazor(FindRazor),
    Shaving(Shave<Yak>),
}

impl Future for ShaveYak {
    type Item = ();
    type Error = ();

    fn poll(&mut self) -> Poll<Self::Item, Self::Error> {
        loop {
            self.state = match self.state {
                YakShaveState::Start => {
                    trace!("Commencing yak shaving");
                    YakShaveState::FindingRazor(find_a_razor())
                },
                YakShaveState::FindingRazor(ref mut find_razor) => match find_razor.poll() {
                    Ok(Async::NotReady) => return Ok(Async::NotReady),
                    Ok(Async::Ready(razor)) => {
                        info!("Razor located: {}", razor);
                        YakShaveState::Shaving(self.yak.shave(razor))
                    },
                    Err(e) => {
                        warn!("Unable to locate a razor: {}, retrying", err);
                        YakShaveState::FindingRazor(find_a_razor())
                    }
                },
                YakShaveState::Shaving(ref mut shave) => return shave.poll(),
            }
        }
    }
}
```

Suppose we spawned this future on an executor that was also running several
other tasks. We might see logs like this:


```
TRACE yaklib::shaving: Commencing yak shaving
DEBUG razors::registry: trying to reclaim unused razors.
 INFO yaklib::yaks::yak_herder: Searching for 27 loose yaks.
TRACE razors::cleaner: Cleaning razor #2
DEBUG razors::registry: 0 unused razors found
 WARN yaklib::shaving: Unable to locate a razor: all razors are in use, retrying
DEBUG yaklib::yaks::yak_herder: Looking for yak "Frank"...
DEBUG yaklib::yaks::yak_herder: Looking for yak "Stephen"...
TRACE yaklib::control::metrics::server: request GET /metrics
DEBUG yaklib::yaks::yak_herder: Looking for yak "Charles"...
TRACE yaklib::control::metrics::server: formatted 50 metrics
 WARN yaklib::shaving: Unable to locate a razor: all razors are in use, retrying
TRACE yaklib::yaks::yak_herder: Looking for yak "Albert"
DEBUG razors::registry: trying to reclaim unused razors
TRACE yaklib::control::metrics::server: formatted 32 metrics
 WARN yaklib::shaving: Unable to locate a razor: all razors are in use, retrying
DEBUG razors::registry: 1 unused razor found
 INFO yaklib::shaving: Razor located: razor #6
TRACE yaklib::control::metrics::server: finished formatting metrics
DEBUG yaklib::yak: shaving yak "George" with razor #6
...
```

The log records generated by the `ShaveYak` future are interleaved with the log
messages output by other tasks running on the executor. Since tasks in an
asynchronous system yield when blocked on IO or on another task, execution
switches between contexts as the executor polls each future, and multiple
futures might be executing concurrently on a thread pool.

If more than one `ShaveYak` future were spawned, we might even see identical log
messages from all those futures mixed together:

```
TRACE yaklib::shaving: Commencing yak shaving
 WARN yaklib::shaving: Unable to locate a razor: all razors are in use, retrying
TRACE yaklib::shaving: Commencing yak shaving
DEBUG yaklib::yak: shaving yak "Frank" with razor #8
 INFO yaklib::shaving: Razor located: razor #5
 WARN yaklib::shaving: Unable to locate a razor: all razors are in use, retrying
 INFO yaklib::shaving: Razor located: razor #12
DEBUG yaklib::yak: shaving yak "George" with razor #5
 WARN yaklib::shaving: Unable to locate a razor: all razors are in use, retrying
 WARN yaklib::shaving: Unable to locate a razor: all razors are in use, retrying
 INFO yaklib::shaving: Razor located: razor #6
...
```

If we're attempting to debug an issue that affected only one of a large
number of concurrently-executing `ShaveYak` futures, it can become increasingly
difficult to isolate the sequence of events that led to the failure. Several of
the log lines in the above example could have been output by any number of
`ShaveYak` futures.

---
layout: post
title:  "tokio-trace"
categories: rust,programming,tokio-trace
author: eliza
---

For the last few months, I've had the pleasure of getting to work on
implementing
[`tokio-trace`](https://github.com/tokio-rs/tokio/tree/master/tokio-trace), a
scoped, structured, and async-aware logging and diagnostics framework for Rust.
In this post, I'll discuss the background and goals behind `tokio-trace`, and
introduce the core principles of its design. Future posts will provide greater
detail on the library's implementation and usage.

## Contents
{:.no_toc}

1. Table of contents
{:toc}

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
on the same thread, associated events and log lines are intermixed, making it
difficult to trace the logic flow.

### A worked example

As an example, let's consider this example from the `log` crate's documentation:

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
<!--
### A real world example

TODO: put sccache stuff here (or should that be its own blog post?) -->

## How do we fix this?

In order to properly understand and debug asynchronous software, we need to
record _contextual_ and _causal_ information.

### Contextuality

In synchronous systems, we can rely on the sequential order of log messages to
infer the contexts of the events they represent. For example, in a synchronous
system, if I see a group of log messages like

```
TRACE server: accepted connection from 106.42.126.8:56975
 WARN server::http: invalid request headers
TRACE server: closing connection
```

I can infer that the request from the client with the IP address 106.42.126.8 was
the one that failed, and that the connection from that client was then closed by
the server. The _context_ is implied by previous messages: because the
synchronous server must serve each request before accepting the next connection,
we can determine that any log records occurring after an "accepted
connection..." message and before a "closing connection" message refer to that
connection.

In asynchronous systems, this method of interpreting logs quicky falls apart.
The task server in the above example may continue accepting new connections
while previously-accepted ones are being processed by other tasks, and multiple
of requests might be being processed concurrently. We don't know that the
request with invalid headers was recieved from 106.42.126.8; the invalid headers
might have been sent on another connection that was being processed while we
waited to recieve more data from that client. To instrument async code
correctly, we need to do more than simply record the data associated with an
event; we must track data associated with the context in which that event
occurred.

### Causality

TODO: writeme

## Prior Art

### Distributed Tracing

`tokio-trace`'s design is inspired by _distributed tracing_ systems such as
OpenTracing, OpenCensus, and Zipkin. These systems provide observability into
distributed systems by associating global identifiers with contexts in a
distributed system, and propagating those identifiers between nodes as the
context travels between them. For example, each incoming HTTP request to a web
application backend might be assigned an identifier, and

## Design requirements

The design of `tokio-trace` is driven by a specific set of requirements. While
we will look deeper into the design choices of the implementation in subsequent
posts, it's worthwhile to take some time now to highlight the requirements and
goals that drive these choices.

### "First, do no harm"

A major goal is that core libraries such as `tokio`, `hyper`, and `h2` should
eventually be instrumented with `tokio-trace`. This goal dovetails directly into
most of the project's design requirements.

Since these libraries are so widely used, it is very important that adding
`tokio-trace` not make them any _worse_. Introducing instrumentation into a core
library should not break existing user code, incur significant performance
overhead, or cause panics that previously would not have occurred.

Additionally, this means that `tokio-trace`'s core libraries must be as
_unopinionated_ and _flexible_ as possible. Users of these libraries likely have
a diverse set of needs and preferences regarding how trace data is filtered,
collected, and reported. If `tokio-trace` were to provide a complete, end-to-end
tracing solution that implemented a particular set of behaviors, and this became
the only way to consume instrumentation in widely used core libraries like
`tokio`, someone would undoubtably be upset about this. Rather, `tokio-trace`
must provide a framework on top of which users can build the tracing behaviour
that their particular use-case requires. Crates built on top of `tokio-trace`
can provide opinionated, batteries-included implementations. This is similar to
how the `log` crate provides a _logging facade_ that defines core primitives for
logging, but allows users to choose from a diverse range of logger
implementations.

<!-- ### Stability

We can model `tokio-trace` as having two distinct API surfaces: the
_instrumentation_ API -->

### Extensibility, compatibility, & composability


### Performance

Any kind of runtime diagnostics --- be it logging, metrics, distributed tracing,
in-process tracing, or "`printf` debugging" --- incurs some runtime cost. In
order to emit diagnostic information, the program must perform some additional
work which would otherwise not have occurred. However, different ways of
collecting and processing diagnostic data can have widely differing performance costs.

For example, if we are logging diagnostic events to standard output, and we wish
for each log line to record some data inherited from the context in which the
event occurred, then we must by necessity allocate memory in which to store this
contextual data. On the other hand, if we are emitting these events to an
out-of-process aggregator, then we may be able to record the context data a
single time, and reference it by an ID when other events occur in that context.
The external aggregator can hydrate contextual data from IDs when displaying the
events, so we need not persist that data once it has been recorded. However,
sending events over the network to the aggregator will likely take longer than
writing to standard out, so we may wish to buffer several events prior to
transmitting them. On the third hand, if we wish to do some form of time-based
profiling, we will need to collect timestamps every time we enter or exit a
context, necessitating a syscall, which other use-cases may not requre.

As different use-cases will incur different performance costs, the primary
performance goal of the core `tokio-trace` libraries is to ensure that
**users only pay for what they use**. This has two separate but interlinked
meanings:

1. Since the behaviour of user-provided `Subscriber` implementations may vary
   widely, **`tokio-trace` itself should not require all `Subscriber`s to pay
   for functionality that not all implementations will require**. As we discussed
   in the example above, not all methods of recording traces will require
   storing contextual data on the heap, so `tokio-trace` itself does not do so.
   Instead, `Subscriber` implementations are given the primitives they need to
   implement this themselves if they require it. Similarly, not all
   use-cases require timestamping trace events, so `tokio-trace` itself does not
   annotate events with timestamps. Again, `Subscriber`s may opt in to this
   behaviour if they choose to.
2. **Disabled instrumentation should be free**. `tokio-trace` allows
   `Subscriber`s to opt out of recording instrumented events, similarly to how
   the `log` crate allows filtering log records. If no `Subscriber` has opted in
   to a particular instrumentation point (or if there are no `Subscriber`s
   active at all), the cost of skipping that instrumentation point should be
   minimal. This means that users are free to add large amounts of
   instrumentation at high levels of verbosity, since the performance costs of
   this instrumentation is minimal when it is not being collected. Additionally,
   it means that if a library adopts `tokio-trace`, the performance cost of
   instrumentation in that library is not inflicted on any users which are not
   themselves using `tokio-trace`.

## How does tokio-trace work?

`tokio-trace` models instrumentation with two core primitives: _spans_ and
_events_. A _span_ represents a period of time in which a program was executing
in a particular context or performing a particular task, while an _event_
represents a singular instant in time when an event occurred. The `Subscriber`
interface allows users and third-party libraries to specify the manner in whicbh
spans and events should be recorded.

### Spans

Spans are `tokio-trace`'s primary tool for modeling context and causation. When
a thread in the program starts executing in a given context, it _enters_ the
span that represents that context; when it switches to a different context, it
_exits_ that span. A span begins when it is entered for the first time, and is
considered over when it has been exited for the last time. Note that entering
and exiting are **not** the same as beginning and ending: since tasks in asynchronous
systems may yield and wake up repeatedly before completing, spans can be entered
and exited any number of time before they end.

When a thread has entered a span, any events that occur on that thread are said
to occur _inside_ that span; this is how contextuality is modeled. Similarly,
spans may be _nested_: when a thread enters a span inside of another span, it
is in **both** spans, with the newly-entered span considered the _child_ and the
outer span the _parent_.

### Events

Events represent something that occurs at a single instant in time --- they are
similar to log messages in traditional logging systems. However, an event exists
in the context of a trace. An event occurs within the context of a span, which
allows multiple sets of events to be correlated.

### Structured data

 `tokio-trace` is a _structured_ diagnostics system. Rather than simply
recording textual messages, `tokio-trace` allows users to annotate spans and
events with typed key-value data called _fields_. This system allows recording
typed values with behaviors more complex than simply writing messages to be
interpreted by a user. For example, a metrics system might be implemented that
uses integer fields to record counters. This also allows serialization of fields
in a machine-readable format.

### Subscribers

In `tokio-trace`, the component of the system that collects and records trace
data is referred to as a _subscriber_. The role of a subscriber is comparable to
that of a logger in traditional logging: when instrumentation generates trace
events, the subscriber recieves and processses them. They are also responsible
for _filtering_ --- determining which spans and events should be recorded.

Also like loggers in other systems, `tokio-trace` subscribers are a pluggable
component. Subscribers implementing a variety of different behaviors may be
provided by third-party libraries or written by the user. The subscriber API is
designed to be as flexible as possible, so that subscribers can provide a wide
variety of functionality. For example, subscribers might:

- Log trace events to standard out or a file as they occu
- Implement a form of profiling by recording the length of time spent in
  different spans
- Emit traces to an aggregator such as OpenCensus or Zipkin
- Implement a metrics system by counting the occurance of certain events or the
  values of certain fields

We'll discuss the details of the subscriber API and how to implement one in an
upcoming blog post.

## Thanks

Thanks to:

 - Carl Lerche (@carllerche)
 - David Barsky (@davidbarsky)
 - Ashley Mannix (@KodrAus)

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

### A real world example

TODO: put sccache stuff here (or should that be its own blog post?)

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

## How does tokio-trace work?

`tokio-trace` models instrumentation with two core primitives: _spans_ and
_events_. A _span_ represents a period of time in which a program was executing
in a particular context or performing a particular task, while an _event_
represents a singular instant in time when an event occurred.

### Spans

Spans are `tokio-trace`'s primary tool for modeling context and causation. When
a thread in the program starts executing in a given context, it _enters_ the
span that represents that context; when it siwtches to a different context, it
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

- Log trace events to standard out or a file as they occur
- Implement a form of profiling by recording the length of time spent in
  different spans
- Emit traces to an aggregator such as OpenCensus or Zipkin
- Implement a metrics system by counting the occurance of certain events or the
  values of certain fields

We'll discuss the details of the subscriber API and how to implement one in an
upcoming blog post.

### Structured data

Finally, `tokio-trace` is a _structured logging_ system. Rather than simply
recording textual messages, `tokio-trace` allows users to annotate spans and
events with typed key-value data called _fields_. This system allows subscribers
to record typed values with behaviors more complex than simply writing messages
to stdout. For example, a metrics system might be implemented that uses integer
fields to record counters. This also allows serialization of fields in a
machine-readable format.

## Design requirements

### Stability

TODO: write me

### Performance

TODO: write me

### Extensibility & composability

TODO: write me

## Thanks

Thanks to:

 - Carl Lerche (@carllerche)
 - David Barsky (@davidbarsky)
 - Ashley Mannix (@KodrAus)

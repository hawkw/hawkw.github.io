<!-- build-lists: true -->

#[fit] this talk is _not_ about
#[fit] **TOKIO-TRACE**
---
<!--
#[fit] why i am the most important
#[fit] **LOGGING** -->
<!-- #[fit] **THOUGHT LEADER** -->

![](thought_leader.png)

---
**eliza weisman**

+ systems engineer at Buoyant
+ tokio, tower, linkerd 2, etc
+ [@mycoliza](twitter.com/mycoliza) on twitter
+ cat liker

^ so, who am I? my name is Eliza Weisman; I'm a systems software engineer at
Buoyant here in San Francisco.

^ I've been writing Rust since 2015, and I've been doing it professionally for
almost two years now.

^ I contribute to the tokio, tower, and linkerd 2 open source projects.

^ Some of you have probably seen my twitter where I post bad programming jokes
and pictures of my cats...

 ---

#[fit] *WHY* I MADE
#[fit] __**ANOTHER**__
#[fit] LOGGING LIBRARY

^ A lot of you are probably wondering why we made another logging library. We
already have logging.

^ Well first of all, I don't like to call it "logging". I prefer to call it "GNU
slash logging".

^ Yes, that was a joke. But what I really prefer to call it is "in-process
tracing". We'll talk about what that actually means a little later.

^ To answer this question, I'm going to start by asking some questions of my
own.

---


#[fit] _HOW MANY OF YOU_
#[fit] ARE USING
#[fit] **FUTURES**?

^ alright, show of hands...how many of you are using futures?

---

#[fit] AND DOES YOUR
#[fit] **LOGGING**
#[fit] MAKE ANY _SENSE_?

^ great. do your logs make any sense? like at all?

---
<!-- ![](before-trace-2.png) -->

<!-- ---

#[fit] *WHY* DID YOU MAKE
#[fit] __**ANOTHER**__
#[fit] LOGGING LIBRARY?

^ A lot of you are probably asking this question.
^ This tokio-trace thing is just another logging library, right? We already have
^ a lot of logging libraries (there's the log crate, slog, env-logger, fern, and so on), why do we need this?

--- -->


#[fit] ASYNCHRONY
#[fit] IS **HARD**

^ Yeah. Async is hard, right? *pause for laughter*

^ If you're writing a high-performance network application, you probably
need to use asynchronous programming. Async presents some unique challenges to
diagnostics.

^ Execution is multiplexed between tasks. When a task is blocked on IO or
another task, it yields, and we start executing another task. The task will wake
back up when IO is ready.

^ Because of this, log messages can end up interleaved, or we can't tell what
context a message happened in.

---
<!-- #[fit] LINKERD

+ open-source _service mesh_
+ adds _observability_, _reliability_, and _security_ to microservices
+ ...without breaking your stuff!
+ linkerd's _data plane_ is written in Rust using Tokio
+ **good _diagnostics_ are key**

^ this is what i do at work :)
^ Linkerd is an open source service mesh; it's infrastructure for cloud-native
applications (a CNCF member project). A *service mesh* consists of a data plane,
a proxy layer that sits in front of application containers and forwards traffic,
married to a _control plane_ that collects instrumentation from the data plane
and controls its behaviour.
^ in the data plane, speed and reliability are very important to us; so we use
Rust extensively. the data plane proxy is a Rust application written in Tokio.

--- -->

#[fit] _HOW_ DO WE GET **USABLE**
#[fit] **DIAGNOSTICS**
#[fit] FROM **ASYNC SYSTEMS**?

^ What do we need in order to get usable diagnostics from async software?
The way I see it, there are three main things we want our diagnostics to
capture: context, causality, and structure.

---

#[fit] **CONTEXT**

^ Context. When we record that an event occurred, we don't just want to know
where in the _source code_ it happened, but in what _runtime context_ as well.

^ For example, if we have a server that's processing requests, the context might
include: what client did this request come from? what where the request's
method, path, and headers?

^ In synchronous code, we can infer context from the order that log records
appear in. But in async code, we switch between contexts, so our diagnostics
need to track them.

---

#[fit] **CAUSALITY**

^ Second, we want to capture _causality_. What other events caused this event to
occur?

^ If some task is running in the background, say, a DNS resolution, or a
database connection, what caused that task to start? Which request required that
DNS resolution?

^ In async systems we can't rely on ordering to determine causality. So again,
we need to record it.

---

#[fit] **STRUCTURE**

^ Traditional logging is based on human-readable text messages. We'd prefer our
diagnostics to record machine-readable structured data.

^ This lets us interact with our diagnostic data programmatically. You can
record typed values and interact with them as numbers, booleans, and so on.

<!-- ---

+ CONTEXT
+ CAUSALITY
+ STRUCTURE

--- -->
<!--
![](before-trace-big-2.png)

^ Let's look at a real world example. This is from sccache.

^ The first thing you'll probably notice is how we have a lot of logs like
"incoming connection" and "handle client". That shows up a lot, right?

^ And then a little later we're compiling some stuff. And we can't really tell
which connection, or which client, resulted in what stuff being compiled.

^ There's no context, and no causality. Async is hard.

---

![](after-trace-big-2.png)

^ Okay, here's sccache again, but with `tokio-trace`.

^ The first thing you'll probably notice is that now we have some contexts.

^ Each client has an ID. So we can see which log lines correspond to which
client.

^ Here we can see that the client with ID 2 caused us to compile the `bitflags`
crate. And the client with ID 3 caused us to compile itoa. -->

---

#[fit] TIME FOR A QUICK
#[fit] **DEMO**

---

#[fit] HOW **TOKIO-TRACE**
#[fit] ACTUALLY **WORKS**

^ So how does `tokio-trace` actually _work_?

---

#[fit] SO WHAT DID I MEAN BY
#[fit] **IN-PROCESS**
#[fit] **TRACING**?

^ Is anyone here familiar with distributed tracing systems? Like OpenTracing,
OpenCensus or Zipkin?

^ Okay, great. These are diagnostic tools for distributed systems. They're
designed for tracking contexts as they move from node to node, so that you can
correlate events on one node with events on another.

^ A key insight behind `tokio-trace` is that asynchronous programs are kind of
like distributed systems writ small. You have concurrently running tasks that
communicate through fallible message passing. The only difference is that
everything lives in one address space.

---

#[fit] **CORE PRIMITIVES**
#[fit] _SPANS_ AND _EVENTS_

^ Our core primitives instrumentation primitives are *spans* and *events*.

---

#[fit] **SPANS**
#[fit] _PERIODS_ OF TIME

```rust
let span = span!(Level::TRACE, "my_great_span");
let _guard = span.enter();
    // do some stuff *inside* the span...
```

^ A span represents a period of time where the program is executing in a
context.

^ Spans have beginnings and ends, and we can *enter* and *exit* them as we
switch between contexts.

---

#[fit] **EVENTS**
#[fit] _MOMENTS_ IN TIME

```rust
event!(Level::Info, "something happened!");
```

^ Events, on the other hand, represent singular instants in time where something
happened.

^ They're analagous to log records in conventional logging. But unlike log
records, they exist in a span context.

---

#[fit] **FIELDS**
#[fit] ADD _STRUCTURED_ DATA

```rust
event!(Level::Info, foo = 3, bar = false);
```

^ Fields are how we attach typed, structured data to spans and events. A field
is a key-value pair.

^ Tokio-trace subscribers can consume field values as a subset of Rust primitive
types.

---

#[fit] AN EXAMPLE

![](yak.jpeg)


^ To put it all together, here's a little example. We're shaving some yaks.

---


```rust
span!("shaving_yaks", yak_count = yaks.len()).enter(|| {

//  for yak in yaks {
//      span!("shave", current_yak = yak).enter(|| {
//          match shave_yak(yak) {
//              Ok(_) => debug!(message = "yak shaved successfully"),
//              Err(e) => warn!(message = "yak shaving failed!", error = field::debug(e)),
//          }
//      })
//  }

})
```

^ So we create a span called "shaving yaks". We're going to do all the work in
there. We annotate that span with the number of yaks we're shaving.

---

```rust
span!("shaving_yaks", yak_count = yaks.len()).enter(|| {

    for yak in yaks {
        span!("shave", current_yak = yak).enter(|| {
//          match shave_yak(yak) {
//              Ok(_) => debug!(message = "yak shaved successfully"),
//              Err(e) => warn!(message = "yak shaving failed!", error = field::debug(e)),
//          }
        })
    }

})
```

^ Then we loop over all the yaks, and we create a new span, "shave", for
each one. The new span is *inside* the "shaving yaks" span. We record which yak
we're currently shaving as a field on that span.

---

```rust
span!("shaving_yaks", yak_count = yaks.len()).enter(|| {

    for yak in yaks {
        span!("shave", current_yak = yak).enter(|| {
            match shave_yak(yak) {
                Ok(_) => debug!(message = "yak shaved successfully"),
                Err(e) => warn!(message = "yak shaving failed!", error = field::debug(e)),
            }
        })
    }

})
```

^ We call this "shave yak" function on the current yak. Anything that happens
in that function is *also* inside the "shave" span, which is nested inside the
"shaving yaks" span.

^ Then, we match on the return value of "shave_yak", and record if it's Ok or an
Error. Since those events are inside the "shave" span, they're annotated with
the yak we're shaving automatically.

---

#[fit] **SUBSCRIBERS**
#[fit] _COLLECT_ TRACE DATA

^ Finally, we have a component called a `Subscriber`. Subscribers are the
component that actually collects and records the trace data generated by our
instrumentation.

^ You can think of a subscriber as being kind of like a logger. And like
loggers, `Subscriber`s are pluggable. This is tokio-trace's main extension point.

^ Libraries can provide subscribers that implement different behavior. One might
print traces to standard out, another might record metrics, and third might send
events to some distributed tracing system.

---

#[fit] HOW TO **USE** IT
<!--
+ pluggable _subscriber_ interface
+ consume log records as events
+ format trace events as log records
+ and... our macros are a _superset_ of the log crate's
-->

^ We've tried to make `tokio-trace` as easy to adopt as possible. This includes
compatibility with other libraries you might already be using.

^ Here are some examples of stuff you can do.

---

**plays nice with futures**

```rust
my_future
   .and_then(|result| {
       debug!("doing something...");
       do_something(result)
   })
   .map_err(|e| {
       warn!(error = field::debug(e));
   })
   .instrument(span!("my_future"));
```

^ It plays nice with futures. Here we're composing a future with some
combinators.

^ We provide this new `instrument` combinator which lets you attach a span to a
future. Whenever we poll this future, we'll enter the span for the duration of
the poll.

^ This means that everything that happens in `my_future`, or in the `and_then`
and `map_err` here, will be inside of the "my_future" span.

---

**this compiles**

```rust
#[macro_use]
extern crate log;

info!("log-style logging! foo={}; bar={}", 42, true);
```

^ We also have drop in compatibility with the `log` crate. Here I'm importing
log and using its `info` macro to log a message. If I want to switch to tokio-trace...

---

**...and so does this**

```rust
#[macro_use]
extern crate tokio_trace;

info!("log-style logging! foo={}; bar={}", 42, true);
```

^ All I have to do is change which crate I'm importing.

^ Tokio-trace has macros that are a superset of log's macros. They can do more
stuff than log, but they support all the same syntax.

^ We also have adapters to let you convert between log records and trace events.

---
#[fit] ONLY **PAY** FOR
#[fit] WHAT YOU **USE**

^ Any runtime instrumentation has performance costs. Tokio-trace's goal is to
ensure you don't pay any costs you don't _have_ to.

^ What does that mean?

---

#[fit] **DISABLED**
#[fit] **INSTRUMENTATION**
#[fit] IS (NEARLY) FREE

^First of all, we've made sure that a subscriber filters
out spans or events you don't want to record, the overhead is basically a single
load and a branch --- under one nanosecond.

^ We cache filter evaluations when possible --- if something is always
disabled, we never need to re-filter it.

---

#[fit] **SUBSCRIBERS**
#[fit] _DON'T_ PAY COSTS
#[fit] BY DEFAULT

^ Furthermore, we've left all the real overhead up to subscriber implementations.
Since different use-cases have different requirements --- some have to allocate
to track data, others need to make syscalls to get timestamps --- `tokio-trace`
doesn't require that _all_ subscribers pay those costs.

---

<!-- #[fit] PERFORMANCE

+ **disabled** instrumentation costs less than 1ns
+ cached **filter evaluations**
+ allocations & overhead are **up to the subscriber**

--- -->

#[fit] let's see some
#[fit] **DEMOS**

---

#[fit] BOOTSTRAPPING
#[fit] **AN ECOSYSTEM**

^ It's worth noting that we're trying to bootstrap a whole ecosystem here. We
released the core library on crates.io today, but that's just the beginning.

^ There's a whole lot of neat stuff we can build on top of tokio-trace together.
I'm sure I haven't even thought of all of it yet.

---

#[fit] GET **INVOLVED**

+ [crates.io/crates/tokio-trace-core]()
+ [github.com/tokio-rs/tokio]()
+ [github.com/tokio-rs/tokio-trace-nursery]()

^ So here's how you can get involved. The first thing you can do is just try it
out. I love bug reports and feature requests, and I love PRs even more.

^ Second, if there's anything you want to see in the ecosystem, maybe you want a
subscriber for your favorite metrics lib, or a different way of formatting trace
logs, please share it! I can't wait to see what people build using
`tokio-trace`.

^ The core crates live in the `tokio` repo, and we have a "nursery" repo for
less stable libraries. A lot of the utility and compatibility crates live there.

---

#[fit] thanks <3

+ Carl Lerche ([@carllerche]())
+ David Barsky ([@davidbarsky]())
+ Ashley Mannix ([@KodrAus]())
+ Lucio Franco ([@LucioFranco]())

^ These are some of the folks who have already helped out a lot.

^ Carl Lerche, of course, is the original author of `tokio`, and he's given me
so much guidance throughout the whole process of writing tokio-trace.

^ I'd like to thank David Barsky for all the conversations we had during the
design and development of tokio-trace, and for the work he did on the
tokio-trace macros.

^ Ashley Mannix is working on adding structured logging to the `log` crate, and
we had some great discussions about how to ensure `tokio-trace` is compatible
with log. He also had some great advice for the design of the `Value` system.

^ Lucio Franco helped out with the nursery crates a lot, especially the format
subscriber.

^ Also, thanks to my partner Tristan, who listened to me practice this talk
several times even though they didn't really understand what it was about.

^ Finally, thanks to all of you for giving your time to listen to me speak about
`tokio-trace` today!'

---

#[fit] **QUESTIONS**?

- email: [eliza@buoyant.io]()
- twitter: [@mycoliza]()
- slides: [elizas.website/slides/]()
- ...or, see me after class!

^ Before I open the floor for questions, here's how you can contact me if
you want to chat about `tokio-trace`, `tokio` or `linkerd`.

^ Also, you can find the slides (and a recording of this talk) at
elizas.website/slides. Feel free to take a picture of this slide if you want to.

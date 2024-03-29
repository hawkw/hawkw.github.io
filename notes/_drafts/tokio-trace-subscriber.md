---
layout: post
title:  "tokio-trace II: the Subscriber API"
categories: rust,programming
author: eliza
---

We can model `tokio-trace` as consisting of two distinct API surfaces: the
_instrumentation_ API and the _subscriber_ API. The instrumentation API refers
to the APIs used to add instrumentation points to library and application code,
while the subscriber API refers to the API used to implement methods of
collecting and recording the data generated by those instrumentation points. The
instrumentation API is comparable to the `log` crate's [logging macros], while
the subscriber API plays the same role as the [`Logger` trait].

The core of the subscriber API is a trait, (perhaps unsurprisingly) named
`Subscriber`, which specifies the core behavior required to record the data
emitted by `tokio-trace` instrumentation. In addition to the `Subscriber` trait
itself, it also includes a small set of types representing the data exposed to
`Subscriber`s as they record instrumentation.

Eventually, we expect that there will be a variety of libraries providing
`Subscriber` implementations providing different functionality. The `Subscriber`
API has been designed to be highly flexible, so that it should be possible for a
`Subscriber` to implement logging, metrics collection, or time-based profiling;
and to record data to disk, an output stream, or to a distributed tracing system or
log aggregator. `Subscriber`s can choose what instrumentation is recorded, and
they may implement any number of strategies, such as filtering source code
locations or contexts, or sampling a percentage of instrumentation.


[logging macros]: https://docs.rs/log/0.4.6/log/#use
[`Logger` trait]: https://docs.rs/log/0.4.6/log/#implementing-a-logger

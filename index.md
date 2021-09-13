---
layout: term
title: eliza's website
cmd: cat about.txt
---

# eliza weisman

## Who?

I'm a [programmer](/code) and occasional [artist](/portfolio), based in Oakland,
California. I'm interested in systems programming, networking, and programming languages.
I'm currently working on open source infrastructure for cloud-native applications at
[buoyant.io](https://buoyant.io).

## What?

Some projects I'm working on include:

+ **[tokio]**: Rust's async runtime
  ([website][tokio]|[crates.io][tokio-crates]|[github][tokio-gh])

  Tokio is an asynchronous runtime for the Rust programming language. It
  provides core primitives like asynchronous IO, timers, a task scheduler, and
  synchronization primitives. I'm a member of Tokio's core maintainer team.

+ **[tracing][tracing-gh]**: Application-level tracing for Rust
  ([crates.io][tracing-crates]|[github][tracing-gh])

  `tracing` is a collection of libraries for adding structured, contextual, and
  async-aware diagnostic instrumentation to Rust programs. `tracing` and its
  ecosystem of crates allow collecting structured, machine-readable execution
  traces from user-defined instrumentation points in Rust programs. This data
  can be used to generate logs, distributed traces, metrics, and more.
  `tracing` is part of the [Tokio project][tokio].

+ **[tokio-console][console-gh]**: A debugger for async Rust ([github][console-gh])

  The Tokio console is a suite of debugging tools for asynchronous Rust
  applications, built on top of [`tracing`][tracing-gh].
  `tokio-console` is part of the [Tokio project][tokio].

+ **[linkerd][linkerd.io]**: Service mesh for Kubernetes
  ([website][linkerd.io]|[github][linkerd-gh])

  Linkerd is a service mesh for Kubernetes: an infrastructure layer for
  distributed applications consisting of lightweight Layer 7 proxies
  that provide security, observability, and reliability for communication
  between services, and a control plane for managing them. I'm one of the core
  maintainers of Linkerd 2's [high performance proxy][proxy-gh].

+ **[mycelium][myco-gh]**: A very silly operating system ([github][myco-gh])

  In my Copious Free Time, I'm working on writing a hobby operating system,
  called `mycelium`. It runs on x86_64, and executes user programs as
  WebAssembly modules...or at least, it *will*, some day. Right now it mostly
  just prints "hello world" and crashes a lot.

[linkerd.io]: https://linkerd.io
[linkerd-gh]: https://github.com/linkerd/linkerd2
[proxy-gh]: https://github.com/linkerd/linkerd2-proxy
[tracing-crates]: https://crates.io/crates/tracing
[tracing-gh]: https://github.com/tokio-rs/tracing
[tokio]: https://tokio.rs/
[tokio-crates]: https://crates.io/crates/tokio
[tokio-gh]: https://github.com/tokio-rs/tokio
[console-gh]: https://github.com/tokio-rs/console
[myco-gh]: https://github.com/hawkw/mycelium

## Contact

+ e-mail:<!--  _eliza (AT) buoyant (DOT) io_ or --> _eliza (AT) elizas (DOT) website_
+ address & telephone number available by request

## Elsewhere

+ code on <a class = "dir" href="https://github.com/hawkw">github</a>
+ keys on <a class = "dir" href="https://keybase.io/hawk">keybase</a>
+ my personal <a class = "dir" href = "https://twitter.com/mycoliza">twitter</a>

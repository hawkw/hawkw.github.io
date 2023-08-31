---
layout: term
title: eliza's website
cmd: cat about.txt
---

# eliza weisman

## Who?

I'm a [programmer](/code) and occasional [artist](/portfolio), based in
California. I like writing the kind of software a lot of people don't think
about that often these days: low-level systems software and infrastructure.

I'm currently working on open source networking infrastructure for cloud-native
applications at [buoyant.io](https://buoyant.io).

## What?

The main projects I'm currently working on include:

+ **[mnemOS]**: A hobby operating system for small computers
  ([website][mnemOS]|[github][mnemOS-gh])

  I've been spending a lot of my free time on [mnemOS], a joint project with my
  friend [James Munns] and a few other folks we've managed to rope into hacking
  on it with us. MnemOS is a hobby-grade, experimental operating system for
  [small computers] (and [bigger ones, too]). It's turned into a really fun
  playground for experimenting with OS design, borrowing some ideas from
  microkernel operating systems as well as the Erlang runtime.

+ **[tracing][tracing-gh]**: Application-level tracing for Rust
  ([crates.io][tracing-crates]|[github][tracing-gh])

  I'm the author and primary maintainer of [`tracing`][tracing-gh], a
  collection of libraries for adding structured, contextual, and
  async-aware diagnostic instrumentation to Rust programs. `tracing` and
  its ecosystem of crates allow collecting structured, machine-readable
  execution traces from user-defined instrumentation points in Rust
  programs. This data can be used to generate logs, distributed traces,
  metrics, and more.

  `tracing` is part of the [Tokio project][tokio].

+ **[tokio]**: Rust's async runtime
  ([website][tokio]|[crates.io][tokio-crates]|[github][tokio-gh])

  I'm a member of the core maintainer team for [Tokio][tokio], the pre-eminent
  asynchronous runtime for the Rust programming language. Tokio provides core
  primitives for asynchronous, event-driven applications, like async IO,
  timers, a task scheduler, and  synchronization primitives.

+ **[linkerd][linkerd.io]**: Service mesh for Kubernetes
  ([website][linkerd.io]|[github][linkerd-gh])

  I'm one of the core maintainers of Linkerd 2's [high performance
  proxy][proxy-gh]. Linkerd is a service mesh for Kubernetes: an infrastructure
  layer for distributed applications consisting of lightweight Layer 7 proxies
  that provide security, observability, and reliability for communication
  between services, and a control plane for managing them.

+ **[tokio-console][console-gh]**: A debugger for async Rust ([github][console-gh])

  I'm the primary maintainer of the the [Tokio Console project][console-gh]. The
  Tokio Console provides a suite of debugging tools for asynchronous Rust
  applications, built on top of [`tracing`][tracing-gh].

  `tokio-console` is part of the [Tokio project][tokio].

+ **[mycelium][myco-gh]**: A very silly operating system ([github][myco-gh])

  In my Copious Free Time, I'm working on writing a hobby operating system,
  called `mycelium`. It runs on x86_64, and executes user programs as
  WebAssembly modules...or at least, it *will*, some day. Right now it mostly
  just prints "hello world" and crashes a lot.


[mnemOS]: https://mnemos.dev
[mnemOS-gh]: https://github.com/tosc-rs/mnemos
[James Munns]: https://jamesmunns.com/
[small computers]: https://github.com/tosc-rs/mnemos/tree/main/platforms/allwinner-d1
[bigger ones, too]: https://github.com/tosc-rs/mnemos/tree/main/platforms/x86_64
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

## WHERE?
### Elsewhere

+ code on <a class = "dir" href="https://github.com/hawkw">github</a>
+ keys on <a class = "dir" href="https://keybase.io/hawk">keybase</a>
+ posts on <a class = "dir" href = "https://twitter.com/mycoliza">twitter</a>
+ Continuity of Posting plan:
  <a class = "dir" href="https://bsky.app/profile/elizas.website">bluesky</a>
  and <a class = "dir" rel="me" href="https://xantronix.social/@eliza">mastodon</a>

### Contact

+ e-mail:<!--  _eliza (AT) buoyant (DOT) io_ or --> _eliza (AT) elizas (DOT) website_
+ address & telephone number available by request

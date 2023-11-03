---
layout: post
title: Five Years of Cloud-Native Rust
---

# Five Years of Cloud-Native Rust: A Reading List

This is a reading list for my talk, ["Five Years of Cloud Native Rust"](https://kccncna2023.sched.com/event/1R2qn/five-years-of-cloud-native-rust-eliza-weisman-buoyant-inc), at KubeCon + CloudNativeCon North America 2023.

This list includes all the sources referenced in the talk itself, as well as other complimentary resources.

> “It doesn’t cease to amaze me that when something finally compiles in Rust, there’s a high chance the program will simply work as intended.”
>  — Alejandro Pedraza ([@alpeb](https://github.com/alpeb)), Linkerd maintainer

## Why Rust?

- **Blog post: [Queue the Hardening Enhancements](https://security.googleblog.com/2019/05/queue-hardening-enhancements.html),** by Jeff Vander Stoep, Android Security & Privacy Team and Chong Zhang, and the Android Media Team ([Google Security Blog](https://security.googleblog.com/), May 9, 2019)
- **Blog post: [Memory Safety in Apple's Operating Systems](https://langui.sh/2019/07/23/apple-memory-safety/)**, by Paul Kehrer ([langui.sh](https://langui.sh/), July 23rd, 2019)
- **Website: [Memory Safety in Chromium](https://www.chromium.org/Home/chromium-security/memory-safety/),** by the Chromium Team ([chromium.org](https://www.chromium.org))
- **Website: [rust-lang.org](https://www.rust-lang.org/)**

## Linkerd's Rust Story

- **Blog post: [Announcing Linkerd 2.0](https://linkerd.io/2018/09/18/announcing-linkerd-2-0/)**, by William Morgan ([linkerd.io](https://linkerd.io/blog), September 18, 2018)
- **Blog post: [Linkerd's Design Principles](https://linkerd.io/2019/04/29/linkerd-design-principles/)**, by William Morgan ([linkerd.io](https://linkerd.io/blog))
- **Talk: [“A Deep Dive Into Conduit’s Rust-Based Data Plane”](https://youtu.be/ig-I1641Gdk?si=PmQH92QQlSBfc4bo)**, by Carl Lerche and Sean MacArthur (2018)
- **Article: [Linkerd v2: How Lessons from Production Adoption Resulted in a Rewrite of the Service Mesh](https://www.infoq.com/articles/linkerd-v2-production-adoption/)**, by William Morgan and Daniel Bryant, (InfoQ, April 5, 2019)
- **Blog post: - [Under the Hood of Linkerd’s State of the Art Rust Proxy](https://linkerd.io/2020/07/23/under-the-hood-of-linkerds-state-of-the-art-rust-proxy-linkerd2-proxy)**, by Eliza Weisman ([linkerd.io](https://linkerd.io/blog), July 23, 2020)
- **Open Source Projects**:
	- [Tokio](https://tokio.rs/), Rust's async runtime
	- [Hyper](https://hyper.rs), a fast, safe, and correct HTTP implementation
	- [Tracing](https://tokio.rs/tokio/topics/tracing), the async-aware logging library I created for Linkerd
	- [H2](https://github.com/hyperium/h2), the HTTP/2 implementation used by Hyper
	- [Tonic](https://github.com/hyperium/tonic), a production-ready gRPC library for Rust
	- [Kube.rs](https://kube.rs/), a Rust Kubernetes client,
	- [Kubert](https://crates.io/crates/kubert), a batteries-included controller runtime for Kube-rs, by the Linkerd team
- **Talk: [“Writing Service Mesh Controllers in Rust”](https://youtu.be/ONkWwoJoF3I)**, by Eliza Weisman (hey, that's me!) (ServiceMeshCon 2022)

## Why It Matters?

- **Article: [Future of Memory Safety](https://advocacy.consumerreports.org/research/report-future-of-memory-safety/)**, by Yael Grauer, ([Consumer Reports](https://advocacy.consumerreports.org/), January 2023)
* **Talk: ["Why the Future of the Cloud Will Be Built on Rust"](https://buoyant.io/media/why-the-future-of-the-cloud-will-be-built-on-rust)**, by Oliver Gould ([Cloud Native Rust Day EU 2021](https://www.youtube.com/playlist?list=PLj6h78yzYM2MKPAas7pxIvueTbwFqVRCX))
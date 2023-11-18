---
layout: post
title: Announcing Maitake-Sync
categories: rust,async
author: eliza
---

It is with a heavy heart that I must inform you that I have written even more
synchronization primitives.

For a while now, one of my primary free-time programming projects has been
[Maitake], an "async runtime construction kit" for bare-metal systems. Maitake
is not entirely unlike [Tokio] --- it's a runtime for [asynchronous Rust
programs][core-task], with a task scheduler, timer, and so on --- but intended
for use on [bare-metal, `#![no-std]`][no-std] systems. The primary use-case for
Maitake has been [mnemOS] (an operating system I'm working on with [James
Munns]) and [mycelium] (my other, older hobby OS project), but the project
provides broadly useful functionality that other folks may find useful as well.

Today, I'm happy to announce [the first crates.io release] of [`maitake-sync`], a
library of synchronization primitives written for Maitake. This crate provides
general-purpose implementations of synchronization primitives, like the ones in
[`tokio::sync`] or [`futures::lock`], but again, designed primarily for use on
bare-metal systems without an OS or the Rust standard library. This means that,
unlike many other implementations of asynchronous synchronization primitives,
most of the APIs in [`maitake-sync`] can be used without dynamic allocation.

Among other things, [`maitake-sync`] includes:

- The obligatory async [`Mutex`] and [`RwLock`], both of which are fairly queued
  (waking tasks in first-in, first-out order),
- An asynchronous [`Semaphore`], based loosely on
  [the implementation I contributed to Tokio][tokio-sem] many moons ago,
- [`WaitCell`] and [`WaitQueue`] types, for when you need to just wake one task,
  or a bunch of tasks, respectively.
- A [`WaitMap`] type, contributed by [James Munns], where waiting tasks are
  associated with keys, and can be woken by their key.

All of these synchronization primtives are implemented using [intrusive] linked
lists, so they require no dynamic allocation for each task that waits on a
synchronization primitive. Instead, the linked list node is inlined into the
task's own allocation (which may or may not be dynamically allocated). This
allows these APIs to be used in environments where dynamic allocations must be
avoided. The [intrusive linked list implementation][cordylist] comes from
another of my hobby libraries, called [`cordyceps`]. Additionally, some of the
code in [`maitake-sync`] uses the bitfield library I wrote one weekend because
I was bored, [`mycelium-bitfield`]. So, it's kind of like "Eliza's greatest
hits".

The synchronization primitives in [`maitake-sync`] are tested using [`loom`], a
model checker for concurrent Rust programs. [`loom`] allows writing tests for
concurrent data structures which exhaustively simulate all the potential
interleavings of operations permitted by the C++11 memory model. `loom` was
[written by Carl Lerche as part of his work on the Tokio runtime][loom-blog],
and it's proved invaluable. I love writing lock-free data structures, but I
don't really trust myself, or anyone else, to write them correctly...without
help from the model checker. [`maitake-sync`]'s synchronization primitives will
also participate in downstream code's [`loom`] models when built with
[`--cfg loom`].

Most of this code has existed for some time, as it was previously part of the
main [`maitake` crate][Maitake]. However, that crate has not yet been published
to [crates.io]. [James][James Munns] recently asked me if it was possible to
publish the synchronization primitives to [crates.io], so that they can be used
without requiring a Git dependency on all of `maitake`. So, today I pulled this
code out of the main `maitake` crate and published it, so that they can be used
without depending on the rest of the runtime.

So, if you're writing an embedded system or an OS in Rust, and you need a
library of asynchronous synchronization primitives, you may find something from
[`maitake-sync`] useful. Enjoy!

[Maitake]: https://mycelium.elizas.website/maitake
[Tokio]: https://tokio.rs
[core-task]: https://doc.rust-lang.org/stable/core/task/index.html
[no-std]: https://docs.rust-embedded.org/book/intro/no-std.html
[mnemOS]: https://mnemos.dev
[James Munns]: https://jamesmunns.com
[mycelium]: https://mycelium.elizas.website
[`tokio::sync`]: https://docs.rs/tokio/latest/tokio/sync/
[`futures::lock`]: https://docs.rs/futures/latest/futures/lock/
[the first crates.io release]: https://crates.io/crates/maitake-sync/0.1.0
[`maitake-sync`]: https://crates.io/crates/maitake-sync
[`Mutex`]: https://docs.rs/maitake-sync/latest/maitake_sync/struct.Mutex.html
[`RwLock`]: https://docs.rs/maitake-sync/latest/maitake_sync/struct.RwLock.html
[`Semaphore`]: https://docs.rs/maitake-sync/latest/maitake_sync/struct.Semaphore.html
[tokio-sem]: https://github.com/tokio-rs/tokio/pull/2325
[`WaitCell`]: https://docs.rs/maitake-sync/latest/maitake_sync/struct.WaitCell.html
[`WaitQueue`]: https://docs.rs/maitake-sync/latest/maitake_sync/struct.WaitQueue.html
[`WaitMap`]: https://docs.rs/maitake-sync/latest/maitake_sync/struct.WaitMap.html
[intrusive]: https://www.boost.org/doc/libs/1_45_0/doc/html/intrusive/intrusive_vs_nontrusive.html
[cordylist]: https://docs.rs/cordyceps/latest/cordyceps/struct.List.html
[`mycelium-bitfield`]: https://crates.io/crates/mycelium-bitfield
[`cordyceps`]: https://crates.io/crates/cordyceps
[`loom`]: https://crates.io/crates/loom
[loom-blog]: https://tokio.rs/blog/2019-10-scheduler#fearless-unsafe-concurrency-with-loom
[`--cfg loom`]: https://docs.rs/loom/latest/loom/#running-loom-tests
[crates.io]: https://crates.io
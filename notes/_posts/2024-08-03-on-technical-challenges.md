---
layout: post
title: "On Technical Challenges: Lock Free Programming"
categories: rust
author: Eliza Weisman
---

The [Oxide Computer Company](https://oxide.computer/) job application
process[^1] asks applicants to answer a set of personal questions about their
career and experiences. I found that the act of writing my answers to these
questions was a remarkably meaningful opportunity to reflect on my career, in
addition to their role in the job application process.

In particular, one of the questions in the Oxide candidate materials asks:
_"What work have you found most technically challenging in your career and
why?"_. I really enjoyed writing my answer to this question — a reflection on
lock-free programming — and I felt like it was worth sharing more broadly.

>
> This is a personal essay, _not_ technical writing. While I discuss technical
> topics in this post, it's intended as a personal reflection on my own
> emotional experiences. I certainly hope that reading this piece inspires you,
> the reader, to learn more about the black art of lock-free programming, it's
> far from the most useful educational resource on the topic.
>
> At the end of this post, I'll include links to some resources where you can
> learn more about lock-free algorithms and data structures, and how they're
> written. 

***

## "what work have you found most technically challenging in your career, and why?"

“Technically challenging” is a difficult term, because there’s been a lot of
work which I’ve found difficult for technical, but not particularly
_interesting_ reasons. Issues like bad tooling, backwards-compatibility, and
awkward API design in a dependency, have all presented their fair share of
challenges, but they’re not particularly fun to talk about. If we throw out all
of this stuff and focus on the challenges that I’ve actually found interesting
rather than just annoying, perhaps the biggest technical challenge I’ve had the
pleasure of experiencing has been writing lock-free concurrent data structures. 

Implementing lock-free algorithms is often incredibly counter-intuitive.  The
kind of linear thinking that both our human minds and most of our programming
languages prefer to use to model the execution of a program — “first, this line,
then, this line, okay, now there’s a branch” and so on — starts to fall apart
when multiple threads of execution are all interacting with the same shared
state concurrently. The first way most of us will attempt to understand a piece
of code is by trying to trace one path of execution through it. But, this
doesn’t help very much when all the state that forms that execution trace might
have changed behind your back every time you looked away from it! A lock-free
algorithm is kind of like an intricate dance, performed on an ice-skating rink,
and all the dancers are holding giant knives. Everything has to fit together
just so, or someone’s face gets sliced open.

Fortunately, we have tools to help us. Unfortunately, those tools are _evil_. My
favorite such tool is [Loom](https://crates.io/crates/loom), a model checker for
concurrent Rust programs. Loom is a library which provides simulated versions of
Rust’s `std::thread`, `std::sync::atomic`, and other standard library APIs. This
allows users to write lock-free data structures and algorithms using these
primitives, and then test their code using Loom’s simulated versions. When
running a test under Loom, the library will perform an exhaustive exploration of
the possible branches allowed by the C++11 memory model (Rust’s memory model),
simulating every potential interleaving of operations across the simulated
threads that the model permits. This means that Loom tests can be rerun hundreds
of thousands of times. 

Picking up Loom after trying to write lock-free code without it feels sort of
like coming to Rust from C++, but for race conditions instead of
use-after-frees. On one hand, now the computer is trying to help you avoid doing
the wrong thing. On the other hand, the only way it knows how to help you is to
keep telling you, over and over again, that you’re wrong. That your code will
fail in one particular weird edge case that you couldn’t have possibly thought
of. Oftentimes, it feels like the tool is not just unforgiving, but actively
malicious, like it’s trying to poke little holes in the beautiful, complex thing
that you’ve spent hours of your brief, precious human life meticulously
crafting.[^2] And, of course, you may find yourself reading through the trace of
one particularly pernicious set of preemptions, and think “okay, but, there’s no
way that this could ever happen in real life, right?”. But that’s the point:
it’s permitted by the memory model, so it can happen in Real Life, and, at
scale, it eventually will. Knowing that is an incredibly humbling experience:
your code contains some ticking time bomb just waiting for the perfect
interleaving of atomic operations that causes it to fail spectacularly. Without
the model checker, would you have ever even realized that?

Over time, you start to learn the moves of this dance. You learn things, like
the importance of trying to cram as much of the system’s state into one
`AtomicUsize`, to avoid situations where some state has been updated but other
state hasn’t been, how to use atomic variables without turning your entire
program into one big compare-and-swap loop, and so on. And eventually, you make
the model checker happy, and you end up with something you can release with a
reasonable amount of confidence. I’ve found this kind of work incredibly
rewarding: it appeals to some part of my psyche that would really like nothing
better than to sit down with a brain-melting little puzzle and spend days on it.
Even with tools like Loom, the puzzles are just as hard, but we can, at least,
avoid the worst failure mode of all: making the assumption that we’ve solved the
puzzle too soon.

***

## further reading

More about `loom`:

- [`loom` API documentation](https://docs.rs/loom/latest/loom/)

Lock-free code I've written, with help from `loom`:

- [`maitake-sync`](https://crates.io/crates/maitake-sync): `![no_std]` async
  synchronization primitives — read the [announcement
  post](https://www.elizas.website/announcing-maitake-sync.html)
- [`cordyceps::MpscQueue`](https://docs.rs/cordyceps/latest/cordyceps/struct.MpscQueue.html):
  intrusive multi-producer, single-consumer queue
- [`sharded-slab`](https://crates.io/crates/sharded-slab): a lock-free
  concurrent slab/object pool/"`Vec<T>` that you can append to concurrently from
  multiple threads"

[^1]: Which you can learn more about on [this podcast
    episode](https://oxide.computer/podcasts/oxide-and-friends/1590191)
[^2]: If you’ve done much work with fuzzing or property testing, you probably
    know how this feels…

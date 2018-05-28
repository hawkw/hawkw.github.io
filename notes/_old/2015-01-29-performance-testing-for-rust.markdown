---
layout: post
title:  "Performance Testing for Rust?"
categories: rust,programming,ideas
---

Here's a quick thought that could potentially be a future research topic. I've previously discussed my [experiences](notebook/rust,programming/2015/01/20/first-steps-in-rust/) learning Mozilla's [Rust](http://www.rust-lang.org) programming language. I've really enjoyed using Rust for my independant study project, [seax](https://github.com/hawkw/seax), a virtual machine for evaluating programs in functional programming languages, especially due to Rust's focus on performance and safety.

As I previously pointed out, Rust is a fairly young language, and the Rust tool ecosystem is still growing. Therefore, there are some significant gaps - many 'old standby' tools that have existed for years in other languages have no equivalent in Rust.

Programming in Scala, I've been really spoiled by the excellent [ScalaMeter](http://scalameter.github.io) performance testing framework. ScalaMeter makes writing performance tests simple and easy, and performs regression analysis to determine if changes have made the execution of a function significantly slower. Rust has excellent [unit testing functionality](http://rustbyexample.com/staging/test.html) built in to the language, but as far as I can tell, there is no equivalent performance testing tools. Since Rust is a language focused on high-performance low level systems programming, it seems to me a good performance testing tool would be nice to have.

Implementing a performance testing tool for Rust would likely not be tremendously difficult. ScalaMeter has to 'jump through a lot of hoops' in order to ensure that the Java garbage collector does not interfere with test results, which would be much less of a problem in Rust, since garbage collection only happens when a program makes excessive use of boxed (heap) objects. However, I still think such a tool would be a fun and potentially useful project to work on.

---
layout: post
title:  "Performance Testing for Rust, Part III"
categories: rust,programming,ideas
---

Just a quick note regarding my [previous](http://hawkweisman.me/notebook/rust,programming,ideas/2015/01/29/performance-testing-for-rust/) [posts](http://hawkweisman.me/notebook/rust,programming,ideas/2015/01/30/performance-testing-for-rust-part-II/) on performance testing in Rust. It turns out that Rust's standard library does have [benchmarking functionality](http://rustbyexample.com/staging/bench.html). However, there doesn't appear to be any mechanism for archiving this benchmark data and analyzing it  to find performance regressions, so there's still an opportunity to extend the currently available functionality.
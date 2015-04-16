---
layout: post
title:  "Alternative Memory Management in Lisp"
categories: ideas, programming, languages, lisp
---

A majority of my friends and colleagues are likely quite aware that I am [very fond](http://hawkweisman.me/seax/background/why-lisp.html) of the Lisp family of programming languages, as it is a subject which I probably talk about somewhat excessively. That Lisp's syntax is both elegantly simple and powerfully expressive is an achievement that I believe can be appreciated on both a practical level and an aesthetic one. Lisp makes it possible to express large and complex concepts both clearly and simply, and it encourages programmers to employ cognitive structures that support efficient, composable, and extensible programming. Frequent readers may also be aware that I am currently working on implementing a [compiler and virtual machine](http://hawkweisman.me/seax/README.html) for executing Lisp programs as part of an independant study this semester.

While languages of the Lisp family are generally excellent choices for many programming projects, they are not particularly well-suited for low-level systems or high-performance programming. These tasks are the sort of thing for which one typically employs C, or occasionally its mutant offspring, C++. One major obstacle facing Lisps in this area is their use of garbage collection (GC) for memory management, an approach which was actually [first used in Lisp](http://en.wikipedia.org/wiki/Garbage_collection_(computer_science)). 

Garbage collection frees the programmer from having to worry about issues such as dangling pointer bugs and memory leaks, providing major improvements in memory safety. However, the addition of a garbage collector to a program's runtime can have significant performance implications, and it is often impossible to provide garbage collection to low-level systems code such as device drivers and operating system components.

How, then, are we supposed to implement these kinds of systems? Must we use C, manage memory manually, and hope dearly that we have not made any mistakes? [Rust](http://www.rust-lang.org), another of my [favourite](http://hawkweisman.me/notebook/rust,programming/2015/01/20/first-steps-in-rust/) [languages](http://hawkweisman.me/seax/implementation/why-rust.html), offers a third option. Rust, which is intended to fill a role similar to that of C++ in systems programming, frees programmers from having to worry about memory leaks without the use of a garbage collector through the use of a fairly innovative [method of memory management](http://paulkoerbitz.de/posts/Understanding-Pointers-Ownership-and-Lifetimes-in-Rust.html) based on the concepts of _lifetimes_ and _ownership_. 

In Rust, a majority of memory is allocated on the stack rather than on the heap, and is therefore deallocated when it goes out of scope. Rust's ownership system allows stack-allocated pointers to be sent to other scopes (e.g. in the case of a function call) either by _borrowing_ or _moving_ the pointer. Ownership of a borrowed pointer returns to the original owner when it leaves that scope, while a move allows ownership to be transferred between scopes. This system allows the compiler to reason about memory in a manner that transfers a majority of the work of memory management from runtime to compile-time.

I've recently reached a point in my SECD machine implementation where I've [begun to consider](https://github.com/hawkw/seax/issues/76) designing a method for memory management on the virtual machine. It is unlikely that I will be able to implement a memory management system within the time constraints of the independant study, but this project is one that I intend to continue developing after the submission date. 

While most Scheme implementations employ garbage collection, I have been considering the use of an alternative system of memory management, perhaps similar to that of Rust. In a [discussion](https://github.com/hawkw/seax/issues/76#issuecomment-93078031) with Dmytro Sirenko, another GitHub user who has also implemented a SECD VM and Scheme compiler, I was informed of the idea of [Linear Lisp](http://home.pipeline.com/%7Ehbaker1/LinearLisp.html), a garbage-collection-free memory management scheme for Lisp, and I intend to do additional research into how alternative methods of memory management, such as Rust's ownership and borrowing, or [region-based memory management](http://en.wikipedia.org/wiki/Region-based_memory_management), may be applied to Lisp-like languages.

Implementing a complete garbage-collection-free Lisp language would be a significant undertaking in language implementation and systems programming, which are two of my greatest interests in computer science. I would love to pursue this idea as a senior project. As I have already put some effort into my work on Seax for my independant study this year, my senior thesis could potentially take the form of an extension of that project to create a high-performance, GC-less Lisp variant.
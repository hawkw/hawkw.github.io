---
layout: post
title:  "First Steps in Rust"
categories: rust,programming
---

Over the last few days, I've had a lot of fun experimenting with Mozilla's [Rust](http://www.rust-lang.org) programming language. Rust is intended for systems programming, with a minimal runtime environment, manual control over memory, and [some pretty impressive performance claims](http://benchmarksgame.alioth.debian.org/u64q/benchmark.php?test=all&lang=rust&lang2=gpp&data=u64q). Basically, it's a modern competitor for C (and, to a lesser extent, Go).

I haven't spent all that much time with Rust yet, and I still have a lot to learn, but I do have some first impressions. I'm pretty impressed with the language, the ideas behind it, and the ecosystem, but there are a few significant flaws, as well.

### The Good

+ Fast
+ Safe manual memory management
+ Modern type system and syntax

Rust presents a really interesting and (as far as I know) unique set of concepts for memory management, eliminating both the garbage collection that makes many modern languages unsuitable for low-level programming, and the myriad memory leaks that plague approximately every C program.

Essentially, the idea is to offload the overhead of managing memory from runtime to the programmer. The way this works is that Rust allocates memory on a stack, and when a scope, such as a function, is exited, the stack is unwound to it's state when the scope was entered, freeing memory allocations 'owned' by that scope. Combined with multiple methods of transferring ownership from one scope to another ('borrowing' and 'moving'), this provides the basis of Rust's memory model. This prevents the additional overhead of garbage collection, allowing fast and low-level programming, but also avoids the memory leaks common in C. Heap-allocated objects ('boxes') are also available, but their use implies garbage collection.

In addition to this novel model for managing memory, Rust also provides a really nice syntax with influence from modern programming languages. In Rust, everything is an expression (a la Scala), so a variable can be assigned to the result of an `if` expression, as in the following example (taken from '[Rust by Example](http://rustbyexample.com/if-else.html)''):

{% highlight rust %}
    let big_n =
        if n < 10 && n > -10 {
            println!(", and is a small number, increase ten-fold");

            // This expression returns an `int`
            10 * n
        } else {
            println!(", and is a big number, reduce by two");

            // This expression must return an `int` as well
            n / 2
        };
{% endhighlight %}

Rust's type system includes support for algebraic data types (ADTs), like those found in Haskell and other functional programming languages. For example, here's the common FP example of Peano encoding for positive integers (taken from '[Rust for Functional Programming](http://science.raphael.poss.name/rust-for-functional-programmers.html)':

{% highlight rust %}
enum PeanoInteger {
   Zero,
   Succ(Box<PeanoInteger>)
}
{% endhighlight %}

This defines a `PeanoInteger` as either `Zero` or one greater than another `PeanoInteger`, encoding all positive integers.

Similarly, here's a definition of a singly-linked cons list using the same ADT syntax:

{% highlight rust %}
enum List<T> {
    Cons(T, Box<List<T>>),
    Nil
}
{% endhighlight %}

This defines a `List<T>` as being either `Nil`, the empty list, or a cons cell containing a `T` and a boxed reference to a `List<T>`. 

It's also possible to define implementations for methods on `enum` and `struct` types. For example, if we want to add a method for prepending an item to our `List` from the previous example:

{% highlight rust %}
impl<T> List<T> {

    // Prepends the given item to the list
    pub fn prepend(self, it: T) -> List<T> {
        Cons(it, box self)
    }

}
{% endhighlight %}

Rust also has a number of other nice features, such as traits, an excellent build system, called `cargo`, support for compile-time macros, and a well designed system for namespaces.


### The Bad

+ Some difficult concepts to learn
+ Very strict

Rust's biggest flaws are that it contains a number of new concepts that don't exist in other languages. New Rust programmers, even if they have a lot of experience in other programming languages, may have to spend some time with Rust before they really understand the various types of pointers, references, and lifetimes available. Unfortunately, this isn't really a problem with Rust, so much as an inherent tradeoff implied by Rust's novel approach to memory management. In return for the performance and safety Rust offers, programmers will have to learn it's concepts and cognitive style.

### The Ugly

+ Still young and unstable
+ Spotty documentation
+ Type inference seems less good than other languages

Other annoyances are mostly related to Rust's relative youth. Mozilla's Rust team [released](http://blog.rust-lang.org/2015/01/09/Rust-1.0-alpha.html) the first alpha of Rust's first stable release only a few weeks ago. All of Rust's 0.* versions were considered unstable, and the language's syntax and libraries change significantly across these versions. What this means is that for any given piece of example code that isn't part of the official documentation, it is entirely possible that that code won't even compile in a current Rust version.

This problem is aggravated by the fact that the available official documentation, which is likely to be up to date, is fairly limited. These problems are related to Rust's youth, and, I hope, will become less severe as the language matures. Hopefully, we will also see more programming tools for working in Rust as well.

My final complaint is that while Rust has type inference, it's type inference seems more easily confused than the type inference in Scala and Haskell, requiring more explicit type annotations. However, this could just be me, and I haven't had enough experience to make a real judgement yet.

### Closing Thoughts

All in all, Rust is a very interesting language with a lot of unique ideas and a lot of promise. Right now, there are a lot of excellent modern programming languages available, with syntax and ideas that allow programmers to write elegant, expressive, and safe code. 

However, a lot of these languages are not suitable for low level systems programming  due to heavyweight runtimes or very abstract language constructs; Scala and Clojure run on the JVM, Haskell is too abstract, Python and Ruby are interpreted languages, and so forth. Rust is one of the few attempts to write a language appropriate for both systems and application programming - unlike any of these other languages, you could write device drivers or a kernel in Rust. 

Beyond this, Rust also introduces a novel approach to safely managing memroy, which, as far as I know, is completely unique to it. Rust is a hugely ambitious project, and I'm really looking forwards to seeing where it goes.


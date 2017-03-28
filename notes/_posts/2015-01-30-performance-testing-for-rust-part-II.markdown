---
layout: post
title:  "Performance Testing for Rust, Part II"
categories: rust,programming,ideas
---

As I mentioned in a previous notebook [entry](http://hawkweisman.me/notebook/rust,programming,ideas/2015/01/29/performance-testing-for-rust/), the Rust programming language lacks a good performance testing tool. I've been thinking about this issue a little bit more today, and I've identified a number of reasons implementing such a tool would be fairly easy. In this notebook entry, I'll briefly discuss how I might go about writing a performance testing tool for Rust.

### Macros

Rust has a powerful [macro system](http://rustbyexample.com/staging/macros.html). Rust macros are keywords expanded into complex syntactical structures at compile-time. Here's a quick example from [seax](https://github.com/hawkw/seax), an ongoing project of mine.

{% highlight rust %}

#[macro_export]
macro_rules! list(
    ( $e:expr, $($rest:expr),+ ) => ( Cons($e, Box::new(list!( $( $rest ),+ )) ));
    ( $e:expr ) => ( Cons($e, Box::new(Nil)) );
    () => ( Box::new(Nil) );
);

{% endhighlight %}

The code in this example defines a macro for creating singly-linked lists. In seax, I've defined a singly-linked list data type, which is either `Cons(T, box List<T>)` or `Nil` (the empty list). This is a pretty simple and elegant list implementation. However, if I want to have a list literal in my program, it looks something like this:

{% highlight rust %}

let list: List<isize> = Cons(1, Box::new(Cons(2, Box::new(Cons(3, Box::new(Nil))))));

{% endhighlight %}

...which is decidedly neither simple nor elegant.

With the macro, I could simply say

{% highlight rust %}
let list: List<isize> = list!(1,2,3); 
{% endhighlight %}

and the compiler would expand it into the structure in the above code snippet.

Rust's standard library makes liberal use of macros. For example, vector literals are declared using a similar `vec!()` macro. 

More interestingly for our purposes here, Rust's unit testing implementation also makes use of macros. A unit test in Rust looks something like this:

{% highlight rust %}

#[test]
fn test_list_length() {
    let full_list: List<i32> = list!(1i32, 2i32, 3i32);
    let empty_list: List<i32> = List::new();
    assert_eq!(full_list.length(), 3);
    assert!(empty_list.length() == 0);
}

{% endhighlight %}

As you can see, `assert!()` and `assert_eq!()` are macros. We could easily imagine a hypothetical performance testing macro, like the following:

{% highlight rust %}

#[test]
fn benchmark_list_length() {
    let full_list: List<i32> = list!(1i32, 2i32, 3i32);
    run_time!(full_list.length(), term::stdout());
}

{% endhighlight %}

The hypothetical `run_time!()` macro takes as arguments function to be run and an output stream to write to. It instruments the function to be benchmarked (in this case, just by getting the timestamp before and after) and writes the result, perhaps along with some identifying information, to the output stream.

### Regression Testing

Wrapping the functions under test in a macro that prints the timestamp to the output stream is all well and good, but if I were to implement a performance testing framework, I would want it to support performance regression testing. 

What's performance regression testing? Think about it this way: If I make some changes to my codebase and then run my unit tests, I'll know right away if something has gone wrong. The testing tool will print a message saying that tests have failed, preferrably in large, red letters. This instantly tells me that my changes to the codebase have broken something. On the other hand, if I make some changes that negatively impact the performance of my program, the performance tests will just spit out a bunch of numbers that can often be difficult to interpret. Performance regression testing stores the results of previous benchmarks and compares them to the current results. If it takes longer to do some function than it did previously, that's a sign that my changes have made that function slower: a performance regression.

The big difficulty in performance regression testing is that performance measurements are not binary, and that there are many sources of variance. Just because a function takes slightly longer to run than it did last time doesn't mean that it's actually gotten slower; rather, the scheduler could have preempted my process to respond to a network request or to run some system service like a backup daemon. In performance regression testing, it's important to make a large number of measurements each time, and compare them statistically rather than individually. If today's set of performance test results show a marked increase in run time than yesterday's, _then_ we might have a performance regression. 

### Cargo

In the Rust community, tests are typically run using [Cargo](http://doc.crates.io), Rust's build tool and package manager. Cargo manages dependencies for Rust projects, and provides a number of useful commands, ranging from `cargo build` for compiling the binaries, `cargo doc` for generating documentation, and `cargo test` for compiling and running unit tests. Since Cargo does everything else, we would probably want our hypothetical performance testing tool to also be a part of the build tool. Therefore, this project would probably involve forking Cargo and adding testing functionality. 

### Test Annotations

In Rust, tests (like the ones we saw above) are made distinct from other code through the `#[test]` annotation. This informs the Rust compiler only to compile these functions when running tests, which allows test and implementation to be side-by-side in the same file. In the Rust idiom, these tests are typically placed within a test module, which is annotated with a similar compiler directive (`#[cfg(test)]`) indicating that the entire module contains only tests.

Performance tests could be annotated with compiler directives, like the `#[test]` annotation discussed above, which could provide `cargo benchmark` with vital information such as where the test results are stored and what statistical analyses to perform on the benchmark results.

Closing Thoughts
----------------

I think writing a performance regression testing tool for Rust would be a lot of fun. What I'm not sure about, however, is whether or not it represents a sufficiently ambitious project to be my senior thesis. I'd really, really like to work on a really challenging, large-scale system for my senior thesis, and I think a performance testing tool for Rust would actually be fairly easy. The implementation of such a tool could potentially be coupled with some empirical studies of Rust programs, perhaps comparing them with C programs.

It's definitely something the Rust community could use, though, especially given Rust's focus on performance and systems programming. My desire for a performance testing tool in Rust is a result of wanting to benchmark certain components of [seax](https://github.com/hawkw/seax), a virtual machine I intend to be used for program execution. Obviously, the VM should be as performant as possible. Similarly, if Rust is eventually employed for tasks like implementing an OS kernel, which it certainly has the potential to be used for, it will definitely be important to have the ability to precisely benchmark performance-critical functions. 

Whether or not it is sufficient in scope to be my senior thesis, a performance testing tool for Rust would certainly be a valuable contribution to the community. Maybe I'll be able to find some spare time to work on it.

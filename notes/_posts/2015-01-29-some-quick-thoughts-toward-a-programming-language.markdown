---
layout: post
title:  "Some Quick Thoughts Towards A Programming Language"
categories: programming, languages,ideas
---

Programming language design and implementation is, in my opinion, one of the most interesting areas in computer science research. I really enjoyed studying compiler implementation in Computer Science 420 last semester, and I'm really interested in learning more about how languages are implemented. 

While the nuts and bolts of language implementation are fascinating, however, an even more fascinating topic is how languages are _designed_. Language design is a really, really important thing to study, since it deeply influences the programs written in a given language, and process of writing those programs, and even the cognitive styles employed my programmers working in those languages. 

I would really love to design and implement a complete programming language. I've implemented and are currently implementing some small 'toy' languages, both in Computer Science 420 and in the independant study I'm currently pursuing with Dr. Jumadinova, but designing and implementing a 'real' language, one that's full-featured enough to be used for writing real software, is a daunting task that might be outside the scope of even a senior thesis. With that said, here are some quick thoughts towards language design.

Compiled vs Interpreted
-----------------------

> "Often people, especially computer engineers, focus on the machines. They think, "By doing this, the machine will run faster. By doing this, the machine will run more effectively. By doing this, the machine will something something something." They are focusing on machines. But in fact we need to focus on humans, on how humans care about doing programming or operating the application of the machines. We are the masters. They are the slaves."
~ Yukihiro "Matz" Matsumoto, *[The Philosophy of Ruby](http://www.artima.com/intv/ruby4.html)*

This would definitely be a compiled language (JVM?), mostly because there's a bunch of stuff that basically says "the compiler should figure this out for you" and if it was an interpreted language, it would probably be painfully slow. I LIKE compiled languages - I like the idea of having the compiler figure it out for you, and if an interpreted language has too many structures which take a long time for the interpreter to figure out, it makes an already slow interpreted language even slower. I'm willing to have longer compile times if it gets me a language that's more versatile & expressive. 

There's a lot I don't like about Ruby (although that's mostly because I don't know it well), but I totally agree with the philosophy suggested by Matz in the above quote - the computer should have to do the work. Language designers should write languages to make programmers happy, not programs. However, if you include lots of structures that are easy for people but hard for machines, you impact performance. In an interpreted language, you parse a difficult structure every time you run the program, wasting time every run. In a compiled language, you parse that structure once, and therefore, you only waste time once.

The other nice thing about compiled languages is, of course, faster execution, and I'm personally all for a compiler that takes a really, really long time to compile the code if the binaries I get out of it are really tense. Execution speed and efficiency are beginning to matter again, with Big Data, mobile computing, and the Internet of Things. Just because your laptop has a quad-core, 2GHz CPU and 8Gb of RAM doesn't mean your code will be running on a machine with that kind of hardware. Differences in performance between the development environment and target environment often mean that it's better to do the Hard Work on the development machine rather than on the machine you're developing for.

> "The #1 Programmer's Excuse For Slacking Off: "My Code's Compiling"."
 ~ one of the most famous [xkcd comics](http://xkcd.com/303/)

Compiling your code used to be slow. Like, get-up-and-make-yourself-a-sandwich slow. Nowadays, it's much faster, especially because a lot of us write primarily/entirely in interpreted languages or for the Web. So why I am I advocating making compiling your code a long, painfully slow process again? Well, there are some significant differences in programming today  that make a long compile step less of a pain than it was in the Days of Yore:

 - **Continuous integration:** Nowadays, most professional developers work in an environment that uses CI and external build servers. This offloads the compile-time slowdown from your machine, so you can keep programming while the CI box builds the project.
 - **Incremental compilation:** A lot of programming languages now have incremental compilers, like Scala's [zinc](https://github.com/typesafehub/zinc). These have the capability to watch a source directory and compile only the *changes* in source code, keeping the already-compiled binaries for everything that hasn't changed. That means if the compiler has parsed that big, expensive language construct or control structure once, it doesn't need to do that every time you change some little thing. This technology is a HUGE boon for languages with long compile steps.
 - **Background compilation:** A related but slightly different technology is background compilation. Pretty much developers have a machine with at least two CPU cores nowdays, so you can be compiling your code WHILE you write code, check emails, or waste time on Facebook. A lot of IDEs hae background compilation baked in - they build the project evern *n* minutes, or after you've changed *n* lines of code. Combine this with incremental compilation, and you can have a theoretically huge compile step, but never actually even have to hit the compile button.

I predict that these technologies will have even more widespread adoption in the future. This is a huge boon for languages which do the Hard Work at compile-time rather than at runtime.

I think we need a resurgence in compiled languages these days. Maybe it's the Web's fault, but it seems like we have a superfluous amounts of interpreted languages. This kinda disappoints me. As I said, I _like_ compiled languages.


Readable Programming vs Literate Programming
--------------------------------------------

In this section, I will discuss two competing approaches towards programming language syntax and documentation. A series of increasingly ridiculous quotes from a conversation in which my colleagues and I repeatedly permuted a sentence and attempted to rationalize each permutation will be used to highlight the various competing perspective.


> "Properly written code doesn't need documentation." 
~ Radu Creanga

In the 80's, Donald Knuth advocated for the idea of *literate programming*, which "represents a move away from writing programs in the manner and order imposed by the computer, and instead enables programmers to develop programs in the order demanded by the logic and flow of their thoughts. (Wikipedia)". The idea is, essentially, you write a bunch of natural language macros for programming language constructs and then string them together. Basically, you are writing documentation and then extracting source from it (yes this is a butchering of Knuth's idea, I need it for the sake of comparison).

I personally am more into the idea of *readable programming* (or "self-documenting code"), probably because I'm lousy at writing (non-sarcastic) comments. The idea here is that the source itself should be readable to people as well as machines (Python is a BIG influence here - I've heard it referred to as "runnable pseudocode"). In comparison with literate programming,  you are writing source, but the source is essentially its' own documentation, or documentation is rendered unnecessary because the source _makes sense_ - both to the author and to other programmers who have to work with or maintain their code. I personally think that the ideal programming language would be one where the code is completely self-explanatory, but that's like an impossible Holy Grail that we should constantly strive for.

Why is readability important? Well, I think we all know that most of the time, if a computer does something wrong, it's not because of a hardware issue, it's because a programmer did something dumb. The only thing programmers do more than write code is make mistakes. Perhaps even more importantly, the only thing harder than writing code on your own is doing it with your friends - the number of mistakes made in any given project frequently seems like an exponential function of the number of programmers in the project. My experience, and that of many others, is that this is mostly because of issues in communication between programmers. This is decidedly not a new observation (see Fred Brooks' seminal text *[The Mythical Man-Month](http://en.wikipedia.org/wiki/The_Mythical_Man-Month)*). Generally, the issues arise when programmers have to make sense of each other's code - remember the old adage "Code like the guy who's gonna be maintaining it is a homicidal maniac who knows where you live."


> "Properly written documentation doesn't need code." 
~ Hawk Weisman


I'm not necessarily arguing in favor of natural-language programming, mind you. Even if we set aside the fact that natural-language programming would be incredibly difficult, if not impossible, to implement (considering that the grammars of most natural languages are so ambiguous that a compiler for natural-language programming would also basically Solve AI Forever), I think natural languages aren't the ideal way to communicate with computers (at least, in the general case). I think it would actually be harder for a programmer to read & parse a computer program written in natural language than it would be to parse a program written in an artificial language that's optimized for readability. Note how pseudocode has syntactic elements not generally present in natural languages. 

In order to implement readable code, you have to make sacrifices somewhere. In Python, they essentially sacrificed programmer freedom for code readability. I think that the Python vs Perl holy war ("runnable pseudocode" vs "runnable line noise") is one of the most significant events in the history of programming language design. Perl let you do whatever you wanted, and therefore let you produce programs that just looked like a bunch of random characters. Python, on the other hand, adopted a philosohphy of "there's only one way to do it", which seems like an overly strict approach but the next major plank in the Python philosophy was "...and that way should be beautiful." It's the old debate of freedom versus conceptual integrity that Brooks writes about in *The Mythical Man-Month*. 


> "Documented code doesn't need properly written." 
~ Tristan Challener


I'd like to avoid sacrificing programmer freedom, at least, I'd like to not have to sacrifice it as much as Python does. I think code is art, and (this is where I wax philosophical for a bit) you can't have true aesthetic beauty in art without freedom & diversity. I like how, for example, Scala lets you write Haskell-esque functional code, "Java without the semicolons", or pretty much anywhere in between; depending on your background, skills, experience, and the needs of the situation. But you have to make the sacrifice somewhere, and I'd rather sacrifice compile time and compiler complexity than programmer freedom, whenever that's possible, going back to the idea of "let the compiler do the work" I mentioned earlier. Of course, this is easy for me to say since I'm just coming up with programming language ideas I'll never actually have to implement.

With all of that said, essentially, my goals are to maximize:

 - *Expressiveness*: I view this as the ratio of Stuff Accomplished:LoC
 - *Readability*: I view this as the ratio of Comments:Code necessary for a program to be understandable to people other than it's programmer.
 - *Versatility*: I'd really LIKE to have a language that is just as useful to a scientist in some Python-esque data-analysis applications but could also be used by a systems programmer writing an OS, but that's probably impossible.
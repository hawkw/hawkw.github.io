---
layout: post
title: A Brief Functional Programming Reading List
categories: programming
---

Frequent readers of my notebook are probably aware that I frequently advocate for the use of functional programming languages such as Lisp, Haskell, and Scala. [Functional programming](http://en.wikipedia.org/wiki/Functional_programming) (FP), a programming paradigm which models program execution as the evaluation of a series of functions and places an emphasis on immutable data structures and avoiding global state, has a number of advantages, including improved testability, more understandable and expressive code, and safer parallelization and concurrency. 

However, many programmers do not to use functional languages or program in the functional paradigm, preferring object-oriented or imperative programming. This is typically either because they are not aware of or not convinced of FP's advantages or because they are not familiar with programming in this way. Therefore, I figured I would assemble a few articles and papers I've recently enjoyed reading into a brief reading list for individuals interested in learning more about functional programming. Some of these are academic papers, while others are written in less formal contexts.

### Haskell vs. Ada vs. C++ vs. Awk vs. ...: An Experiment in Software Prototyping Productivity

In this 1994 [paper](http://www.cs.yale.edu/publications/techreports/tr1049.pdf), authors Paul Hudak and Mark P. Jones discuss the results of a study on software prototyping conducted at the Naval Surface Warfare Centre. In the experiment, experts in various programming languages were tasked with creating a prototype of a component of a Navy software system. The performance of each language was tracked by the researchers. 

Hudak and Jones focus primarily on the functional programming language Haskell, highlighting how the Haskell solution was implemented much quicker and in significantly fewer lines of code than a majority of the competing languages. They discuss the features of both Haskell in particular and functional programming in general which make it ameniable to rapid and efficient prototyping for software systems.

In my opinion, this paper is a very effective argument in favour of functional programming for those who question its advantages over other programming paradigms. The statistics presented by the authors, demonstrating that the Haskell system was implemented much faster than imperative languages and in many fewer lines of code, are very telling.

### Why Racket? Why Lisp?

In this [chapter](http://practicaltypography.com/why-racket-why-lisp.html) from the book _Practical Typography_, typographer Matthew Butterick discusses his choice of the Racket programming language, a member of the Lisp family, to implement his typesetting system [Pollen](http://pollenpub.com). Butterick is a typographer and designer by trade, not a programmer, so the outside perspective on Lisp he provides is, in my opinion, quite fascinating. His thoughts are an excellent illustration of the strengths of the Lisp language family for beginning programmers, experts, and about everyone in between.

### Haskell as a Teaching Tool

The ability of functional programming as a method for teaching mathematics is highlighted by two rather different publications. In ["Learn Physics by Programming in Haskell"](http://arxiv.org/abs/1412.4880), Steve N. Walck provides an introduction to Newtonian mechanics and electromagnetic theory using the Haskell programming language, with no prior experience in either programming or physics assumed. In addition to teaching the reader about physics, I think that this lesson very effectively demonstrates how FP concepts, such as type aliases and higher-order functions, are effective in representing real-world systems and decomposing problems.

Another interesting article on the subject is blogger 'superginbaby''s [thoughts](https://superginbaby.wordpress.com/2015/04/08/teaching-haskell-to-a-10-year-old-day-1/) on teaching Haskell to her ten year old son. I feel like the ease with which her son picks up fairly complex mathetmatical concepts through experimentation with an interactive Haskell session are a strong demonstrator of both the applicability of functional programming to math education and to the ease by which functional programming can be learned. This is, I think, excellent evidence to contradict the all-too-common stereotype of functional programming as being more complex or difficult than other programming paradigms.

### Martin Odersky's Scala Rationale

In this [short document](http://www.scala-lang.org/docu/files/ScalaRationale.pdf), Martin Odersky, the creator of Scala, briefly enumerates some of the major ideas that inform the design of that language. Scala is one of my favourite programming languages, and it was designed with a great deal of care and knowledge. Reading Odersky's thoughts shine a lot of light on the considerations behind good programming language design.

For those who find that this three-page document just piques their thirst for more, Odersky's [introduction](http://www.artima.com/pins1ed/a-scalable-language.html) to the book _Programming in Scala_ (the first edition of which is [available free online](http://www.artima.com/pins1ed/index.html)) is certainly worth reading. 

### John Carmack on Functional Programming in C++

Game developer [John Carmack](http://en.wikipedia.org/wiki/John_Carmack) is likely one of the most talented progammers currently active; his pioneering work at Id Software has made the three-dimensional video game possible. Regardless of the reader's interest in gaming, Carmack's programming achievements are quite impressive. In [this column](http://gamasutra.com/view/news/169296/Indepth_Functional_programming_in_C.php), Carmack discusses his perspectives on functional programming. He suggests (correctly) that FP is not a group of languages, but a philosophy for approaching programming in any language. He breaks down functional programming for the working software developer, and discusses how principles learned from FP can be applied to programming in a variety of environments.

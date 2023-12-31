---
layout: post
title: "On Beginner's Mind in Software Engineering"
---

On a whim, I picked up a copy of the book [_The Creative Act: A Way of
Being_](https://www.penguinrandomhouse.com/books/717356/the-creative-act-by-rick-rubin/)
at [First Light Books](https://www.firstlightaustin.com/) in Austin, Texas. I
hadn't heard of the book before, but as I skimmed the first chapter, I was
struck by the way the author wrote about the creative act as integral to so many
pursuits in life beyond art-making and other things we typically think of as
"creative work". This resonated deeply with my own conception of programming,
and engineering more broadly, as a creative pursuit with at least as much in
common with artistic work as with the natural sciences, so I felt like I had to
pick up a copy.

So far, I've really enjoyed the book. As I was reading, I decided to look up the
author, [Rick Rubin](https://en.wikipedia.org/wiki/Rick_Rubin), because I hadn’t
heard his name before. Apparently, he's' music producer, who worked on a lot of
famous records. Reading through his Wikipedia article, I thought this passage
was particularly interesting:

> In 2022, Black Sabbath bassist [Geezer
> Butler](https://en.wikipedia.org/api/rest_v1/page/mobile-html/Geezer_Butler
> "Geezer Butler") said of Rubin's production of the band's 2013 album _13_:
> "Some of it I liked, some of it I didn't like particularly. It was a weird
> experience, especially with being told to forget that you're a heavy metal
> band. That was the first thing [Rubin] said to us. He played us our [very
> first
> album](https://en.wikipedia.org/api/rest_v1/page/mobile-html/Black_Sabbath_(album)
> "Black Sabbath (album)"), and he said, 'Cast your mind back to then when there
> was no such thing as heavy metal or anything like that, and pretend it's the
> follow-up album to that,' which is a ridiculous thing to think."
>
> &mdash; from ["Rick Rubin" on
> Wikipedia](https://en.wikipedia.org/wiki/Rick_Rubin#Criticism)

Although I can imagine how this must have felt strange to Butler, who just
wanted to record a new record, I actually think the idea Rubin was getting at
with this was valuable and worthy of thought. right. Maybe it is a ridiculous
thing to think, in some ways, to imagine a work existing in a vacuum without the
cultural context around it, but it’s an incredibly useful exercise to return to
the blank canvas like that: you can’t make the record that creates the genre of
heavy metal, if heavy metal music already exists. There's an idea in Zen
Buddhism, [_shoshin_ (初心), or "beginner's
mind"](https://en.wikipedia.org/wiki/Shoshin), which refers to the concept of
approaching a practice or activity as though we are doing it for the first time,
even if we've done it many times before. In doing so, we can leave behind our
preconceived ideas and biases, and approach the practice with an open mind. I'm
pretty sure Rubin was drawing on this idea from Zen thinkers when he gave his
advice to Black Sabbath.

I think there’s something similar we ought to do in software design. Software is
a field where we do _so_ much thinking about the software that already exists,
and there very good are reasons for this. A lot of the time, the new systems we
create have to interact with existing systems. or, they exist in dialogue with
their antecedents: so many software systems are created as replacements for
earlier ones, and we think about them as “a better version of _X_”, or “a
version of _X_ but with support for _Y_ and _Z_”, or “a faster _X_”, etc. 

It seems to me that there can be a lot of value in approaching these things as a
blank slate. Instead of thinking “I’m going to make a better version of
Kubernetes”, for example, we can instead try to imagine the system we would
design if Kubernetes didn’t exist. By practicing this, perhaps we can avoid the
baggage of our predecessors and their assumptions when we are creating something
that exists in a new context with different assumptions. 

This is particularly valuable when the constraints and assumptions of the new
system have changed substantially relative to its predecessors. As a (somewhat
contrived) example, the C programming language famously requires [forward
declarations](https://en.wikipedia.org/wiki/Forward_declaration): a name, such
as for a function or data type, must be defined earlier in the source code file
than where it is referenced. There is a reason for this: early compilers, such
as the first C compilers, were [_one-pass
compilers_](https://en.wikipedia.org/wiki/One-pass_compiler). They would iterate
over the source code file a single time, emitting the compiled machine code as
they traversed the source. This design was a direct result of the limitations of
the computers these compilers ran on: with limited memory, there may not be
enough space to store the large intermediate representations required by
multi-pass compilers. Modern systems, on the other hand, have plenty of memory,
and almost all modern compilers are multi-pass. Someone designing a new language
who had only written C might not recognize that the requirement for forward
declarations in C only exists due to the hardware limitations of 1970s
minicomputers. By deliberately forgetting some of what they know about C, on the
other hand, the language designer can approach the problem without carrying
forward design choices that were deliberately made due to constraints and
requirements that no longer apply to the new language.

> "In the beginner's mind there are many possibilities, but in the expert's mind
> there are few." &mdash; ["Zen Mind, Beginner's
> Mind"](https://search.worldcat.org/title/136259) by [Shunryū
> Suzuki](https://en.wikipedia.org/wiki/Shunry%C5%AB_Suzuki)

On the other hand, though, it’s important to learn from prior art and existing
solutions. Both from their successes, and the techniques they used to solve the
same problems, _and_ from the things they get wrong, the ways those existing
solutions are insufficient. I do think there's kind of a common attitude in
software of "we don't need to learn about the things that have come before us,
and we can just build new layers in the stack on top of them". This way of
thinking often results in people reinventing the wheel, and frequently making
the same mistakes over and over again. For example, we might want to be able to
write highly concurrent software, and find ourselves limited by the overhead of
OS thread context switches. Instead of improving the OS scheduler and optimizing
context switch performance, we might choose to implement [green
threads](https://en.wikipedia.org/wiki/Green_thread)...and end up having to
solve basically the same scheduling problems as the underlying OS scheduler.
Perhaps it was necessary to use green threads &mdash; maybe we can't feasibly
make context switches any faster &mdash; so this might be a valid design choice.
But, if we're going to implement our own scheduler in userspace, it would almost
certainly be a mistake to not learn about the scheduling techniques used in the
underlying OS. Otherwise, we might make some naive mistakes that the kernel
developers already made and learned from.

So, maybe we should first do some ideation on a blank slate, without looking at
existing systems, and _then_ look at what other systems do.  We can come up with
potential design ideas untainted by prior art, and then compare and contrast our
ideas with what others have done. And, I think there's maybe a difference
between learning about and understanding your _dependencies_, and learning about
other software that solves the same problem.

In some ways, practicing beginner's mind is kind of what [James
Munns](https://jamesmunns.com/) and I are doing with
[mnemOS](https://mnemos.dev), our hobby operating system. We're not trying to
build a clone of Linux that can run any
[POSIX](https://en.wikipedia.org/wiki/POSIX)-compatible binary. we're doing [a
new thing, with very different
assumptions](https://onevariable.com/blog/mnemos-moment-1/)...which is a freedom
afforded by being a pure hobby project. We _have_ ended up being influenced by a
lot of ideas from throughout the history of computing, like
[Erlang](https://en.wikipedia.org/wiki/Erlang_(programming_language)),
[microkernels](https://en.wikipedia.org/wiki/Microkernel),
[Forth](https://onevariable.com/blog/mnemos-moment-2/), et cetera. but a lot of
these ideas aren't really part of the *current* crop of modern operating
systems. It's kind of as though we aren't really looking at our contemporaries
(like Linux), but we _are_ looking at our shared antecedents. Instead of writing
mnemOS in a post-Linux world, we are kind of pretending we are writing mnemOS
starting from the same place where Linus started writing Linux. And maybe that's
sort of like what Rick Rubin meant about "pretending heavy metal doesn't exist":
you don't pretend that rock'n'roll doesn't exist, or that the guitar doesn't
exist, because you can't create the first heavy metal album without those
things. But, you do try to imagine you're starting over from the same place
where heavy metal actually _did_ start.

I guess the concluding thought here is just that there's value in cultivating
beginner's mind in software development...but there's _also_ just as much value
in being able to learn from our field's rich history. There's a time and a place
for both, and the best designer is one who is able to both approach the world
without biases _and_ look to the past for inspiration. Balance in all things.
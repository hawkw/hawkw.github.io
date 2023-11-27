---
layout: post
title:  "On New Years and New Beginnings"
---

> “Five-year goal: Build the biggest computer in the world. One year goal:
> One-fifth of the above.”
>
> — [attributed to Seymour Cray]

A new year is always a fitting time for new beginnings, and I'm excited to share
that I have a pretty big new beginning coming up: I've accepted a job at [Oxide
Computer Company], starting in January of 2024!

I’ve been a huge fan of Oxide for quite some time, because of both what they’re
doing and the way they’re doing it. Building a rack-scale, fully-integrated
[cloud computer] is an exciting, ambitious project, and it’s exactly the kind of
thing I’m interested in: infrastructure and systems at the hardware-software
interface. I’m just as excited about the approach they’re taking to accomplish
that goal: thoughtful, deliberate, and with a commitment to quality and rigor. I
love that Oxide’s engineers aren’t afraid to invest in tools and infrastructure
— they’ve created both [their own embedded operating system][hubris], _and_ [a
purpose-built debugger specifically for that system][humility]. This commitment
to spending the time and energy necessary to create something that’s sustainable
in the long term has always impressed me. Clearly, Oxide is willing to look to
the past with respect and learn from our predecessors and their choices, but
also unafraid of building new things in parts of the stack where no one else
seems to want to. And, finally, these people all seem to just _really love
computers_: any company where employees [tweet excitedly about their PCI vendor
ID][pci-tweet] definitely feels like a place where I’d fit in!

Of course, this kind of new beginning always has a cost: it’s going to
be really hard for me to say goodbye to the team at [Buoyant], and all
the things we’ve done together. I’m grateful to have [gotten to help
build so much][l5d-commits] of [Linkerd] and I’m even more grateful for
everything I’ve learnt while I was at Buoyant, especially from people
like [Oliver Gould], [Alex Leong], and [Carl Lerche]. Leaving such a
talented, thoughtful, and kind group of people is painful, but I think
this is an important next step on my path. Thank you so much to everyone
at Buoyant! It’s been an honor and a privilege, and I’m sure some of our
paths will cross again in the future!

The Oxide job application process[^application] asks applicants to answer a set
of personal questions about their career and experiences. I found that the act of
writing my answers to these questions was a remarkably meaningful opportunity to
reflect on my career, in addition to their role in the job application process.
One of those questions asks the candidate to choose one of Oxide’s [company
values][values] and write about how that value has been reflected in their work. I chose
to write about the value of _curiosity_, and I think what I wrote ended up
saying a lot about why Oxide, in particular, is so exciting to me. I think my
answer might be the best way I can truly express why joining the team at Oxide
is an important next step on my path, so I’ll conclude this post with that.

***

## On Curiosity

Of all of Oxide’s [values], the one that resonates with me the strongest is
*curiosity*. Curiosity is what drew me to software, and to systems software in
particular, in the first place. My love and fascination with operating systems
can be traced back to a particular childhood memory, from when I was maybe eight
or nine years old.

My father, now a college art professor, began his career as a graphic designer,
and we were always a Macintosh household. As a child, I was always fascinated by
infrastructure (a love which was also part of what led me towards systems
software), so naturally, I was friends with other kids who had similar
interests. One of my friends was a boy who loved trains, and we would hang out
at his house playing train games on his family’s computer. One time, he had his
dad burn a CD with a copy of a train game — I think it was Railroad Tycoon? —
for me. Excited by this act of software piracy, the first thing I did when I got
home was to stick the CD into my hand-me-down Power Macintosh G3, expecting
Railroad Tycoon to start. What I got, however, was not Railroad Tycoon, but a
mysterious CD full of strange files with extensions like ‘.exe’. It was, of
course, a Windows build of the game that wouldn’t run on my Mac. 

I was, of course, disappointed. But more than that, I was fascinated. Why was it
that the game worked on my friend’s computer, but not on mine? Was there
something that I could do to make it work? I was entranced by my newfound
knowledge that there was something called an ‘operating system’, and something
called an ‘instruction set architecture’ and an ‘executable format’, and that
these were parts of the magic box of lights that made Railroad Tycoon work, and
furthermore, that there were people called ‘programmers’ who understood the Deep
Magic of this hidden world, and that you could become one of them if you were
good at math (which I wasn’t, really). This was also a kind of infrastructure,
which was actually far more interesting than the fact that I couldn’t play
Railroad Tycoon, no matter how much I wanted to.

This was one of the moments that set me on a path which led me to check out a
book on HTML from the school library and make some truly terrible websites, and
then eventually to teach myself a bit of one of the bad latter-day BASICs
(RealBASIC, maybe?) in middle school, and a bit of Python in high school, and to
enroll in Intro to Computer Science at my small liberal-arts college. In my
junior year, I would excitedly sign up for Computer Science 440, “Operating
Systems”, only to be disappointed when the syllabus was handed out and I learnt
that we wouldn’t actually be writing any operating systems in class. This was
also around when my curiosity about programming languages that weren’t
Java[^java-school] led me to Rust. The pitch in the HackerNews post was
something along the lines of ‘you could write an operating system in this
language’, so, naturally, I had to do that, in my Copious Free Time (and, I’ll
admit, occasionally in class). That was my first hobby OS, circa
2015-2016, and since then, I’ve always been hacking on an OS project whenever
I’ve had spare time to hack on stuff.[^hobby-os]

Curiosity has always been a big motivation, or perhaps the biggest motivation,
behind my work. It’s what draws me to peel back the layers of abstractions we
build our systems on top of, to learn what’s going on beneath them. It’s why I
always want to seek out problems which cannot be solved effectively without a
deep understanding of the lower levels of the system. Curiosity is what makes us
want to learn about the parts of the software and hardware stack that some
engineers take for granted. It’s curiosity that leads us to question whether
established systems (say, Unix, C, BMC firmware…) are really as good as it gets,
that makes us ask whether we really have to accept the limitations of the
platforms that everyone else seems to want to build on. But it’s also because of
curiosity that we seek to understand the choices and constraints of those who
came before us, that makes us wonder “what was their reason for doing it that
way?” and to find the answers to that question. Curiosity shows us the things we
can improve on, but it also teaches us not to blindly reinvent the wheel just
because we can; teaches us both to respect the wisdom of previous generations of
engineers, and how to avoid making their mistakes.

[attributed to Seymour Cray]: https://en.wikipedia.org/wiki/Seymour_Cray#Personal_life
[Oxide Computer Company]: https://oxide.computer
[cloud computer]: https://oxide.computer/blog/the-cloud-computer
[hubris]: https://hubris.oxide.computer/
[humility]: https://github.com/oxidecomputer/humility
[pci-tweet]: https://x.com/jmclulow/status/1229923714218594305
[Buoyant]: https://buoyant.io
[l5d-commits]: https://github.com/linkerd/linkerd2-proxy/commits?author=hawkw
[Linkerd]: https://linkerd.io
[Oliver Gould]: https://github.com/olix0r
[Alex Leong]: https://x.com/alexicographic
[Carl Lerche]: https://carllerche.com/
[values]: https://oxide.computer/principles

[^application]: Which you can learn more about on
    [this podcast episode](https://oxide.computer/podcasts/oxide-and-friends/1590191).

[^java-school]: It was, sadly, a Java School...

[^hobby-os]: See [Mycelium](https://mycelium.elizas.website) and, more recently,
    [mnemOS](https://mnemos.dev).
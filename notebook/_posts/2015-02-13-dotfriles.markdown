---
layout: post
title:  "Dotfriles: A Simple Tool For Managing Configuration Files"
categories: programming
---

I've lately been making some changes to my configuration files for various Unix tools, and I thought it was worth sharing a tool that my colleague Max and I implemented last summer. [Dotfriles](https://github.com/hawkw/dotfriles) is a set of shell scripts which provides a very simple method of managing user configuration files on Unix operating systems. 

Dotfriles uses Git to manage user configuration files, and can be used to easily restore those files in the event of a system failure or when configuring a new computer. The Dotfriles shell script symbolically links configuration files from the Git repository into the user's home directory.

Max wrote the [original version](https://github.com/ArcticLight/dotfriles) of Dotfriles, and I've since released a [fork](https://github.com/hawkw/dotfriles) which adds a number of additional features. My fork adds the ability to automatically install a list of packages stored in the repository, support for managing the configuration files for the SublimeText text editor, and support for the Mac OS X operating system by linking SublimeText configuration into the correct location and by using different package managers depending on the operating system.

Recently, working on customizing my configurations for various tools inspired me to continue working on Dotfriles. Currently, the script only uses the Homebrew package manager (on Mac OS X) or the `apt` package manager (on Ubuntu and other Debian-like operating systems). I'd like to add support for the package managers used by other Unix operating systems. I'd also like to add special-case support for other editors and tools that store their configuration files outside of the user's home directory or in different locations depending on the OS. Managing Python `virtualenv`s with different lists of `pip` modules would also be a nice feature.

Dotfriles is not a complex software system --- it's just a short set of shell scripts --- and it's definitely not an ambitious enough project for a senior thesis in computer science. It has been a fun learning experience to work on, though, and was one of my first major experiences with bash scripting.
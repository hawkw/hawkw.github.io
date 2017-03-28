---
layout: post
title:  "The Mobile Shell"
categories: tools
---

I've used `ssh(1)` quite frequently for administrating a remote computer over a network connection. Using `ssh` is very easy - it ships with pretty much any POSIX-compatible operating system and requires very little configuration and setup to use, unlike graphical remote desktop tools.

However, `ssh`, which was first developed in 1995, was not really designed with modern mobile computing in mind. It does not support roaming, so if you open a `ssh` connection from a laptop or mobile device, and then switch to a different device, changing your IP address, any running `ssh` sessions will be disconnected. The same will happen if you put your laptop to sleep, or if your internet connection is temporarily interrupted. Furthermore, if the internet connection is slow or has a high packet loss rate, entering commands using `ssh` may often be difficult, as it sends characters to the remote machine one at a time.

Fortunately, a group at MIT has a solution. They have released a new program, called Mobile Shell, or [`mosh(1)`](https://mosh.mit.edu). Unlike `ssh`, `mosh` supports roaming and intermittent connectivity, and will reconnect in the event of temporarily service interruptions. It buffers keystrokes and predicts the remote machine's responses, correcting for network lag and allowing commands to be issued seamlessly. As is obvious from its' name, `mosh` is designed from the ground up for mobile use. 

Furthermore, both the `mosh` shell and the server may be run unpriveliged by a regular user. It is available on almost all popular package-managers for Unix and Linux operating systems, including Homebrew and MacPorts for Mac OS X, as well as on Windows using Cygwin. Additionally, a browser plugin for Google Chrome and Chrome OS is also available.

I've often suggested that there is a need for continual updating of the common tools used by computer scientists and computing professionals. To me, `mosh` is evidence that there is plenty of room for improvement, even for the tools that almost everyone uses.
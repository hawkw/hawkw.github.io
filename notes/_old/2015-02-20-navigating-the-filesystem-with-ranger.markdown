---
layout: post
title:  "Navigating the File System with Ranger"
categories: tools
---

I like to do as much work as possible from the command line, rather than using the GUI. A lot of my favourite programming tools run in the terminal, so I often find switching between GUI applications and terminal applications to be jarring and distracting. Therefore, I do a lot of filesystem navigation in the terminal.

Typically, when I already know the structure of a directory tree, Unix `cd` and `ls` are more than sufficient for file-system navigation. Using `cd` to go directly to a directory is in fact often much quicker than the equivalent set of GUI actions. However, when the structure of the directory tree is unknown, such as when exploring a Git repository for a project you wish to contribute to, the repeated use of `cd` and `ls` to explore the directory tree can be somewhat time-consuming.

Therefore, there's definitely a niche for more sophisticated file-system browsers in the command line. My favourite is [`ranger`](http://ranger.nongnu.org). `ranger` is a three-column file browser, not unlike [Midnight Commander](https://www.midnight-commander.org) or the Mac OS's column mode.

Probably my favourite `ranger` feature is that it's written and configured using Python, meaning that modifying `ranger` is extremely easy. It loads and runs a set of runtime config files from the user's home directory. These configurations are all Python scripts, making it easy to add new functionality. For example, you can check out [my `ranger` config scripts](https://github.com/hawkw/dotfiles/tree/master/.config/ranger) in my dotfiles repository. I add a number of features, including support for Git status, and add a customized color scheme.

Another nice thing is that `ranger` is very smart about opening files. It uses the user's default editor to open source-code files, allows for previewing images in the file browser, and can even intelligently determine the user's operating system and open directories in the OS's GUI.

`ranger` is a great example of a simple and yet infinitely extendible tool. I strongly recommend it.
---
layout: post
title:  "SLAM on the GPU?"
categories: robotics,ideas
---

This is just a quick thing that I thought of, but I figured it was worth jotting down. 

[SLAM](http://en.wikipedia.org/wiki/Simultaneous_localization_and_mapping) stands for <i>s</i>imultaneous <i>l</i>ocalization <i>a</i>nd <i>m</i>apping, and refers to the problem of a robot attempting to find its' own location in an environment while simultaneously constructing that environment. There are a number of algorithms, such as Kalman filtering and Monte Carlo methods, for performing this task.

Today in my robotics class (Computer Science 383), we were watching some videos showing robots attempting to navigate unknown envrionments using SLAM techniques. In one video, a "robot's-eye view" was shown, with a note that the SLAM code was executing on a Core 2 Duo processor. This got me thinking: it seems to me that this kind of mapping is a fairly computationally-intensive task, probably one of the most demanding tasks in a robot's control software. It also seems like some of the components of robot navigation, such as edge detection, are very similar to common tasks in 3D graphics. I began to wonder if it might be possible to adapt some parts of the graphics pipeline to carry out these tasks more efficiently than on general-purpose CPUs.

I don't have all that much expertise with robot navigation - we're just now beginning to cover it in class - and I know next to nothing about GPU programming, GPGPU and otherwise, but I thought this was an interesting idea.
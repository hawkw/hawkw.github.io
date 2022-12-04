---
layout: dir
title: elizas.website/notes
cmd: "ls -la"
pwd: notes
---

<nav class="term">
    total {{ site.posts.size | plus: 5 }}
</nav>
<table class="term">
    <nav class="term">
        <tr>
            <td>drwxr-xr-x</td>
            <td class = "term num">32</td>
            <td>eliza</td>
            <td>users</td>
            <td class = "term size">64</td>
            <td>{{ site.time | date: "%b" }}&nbsp;{{ site.time | date: "%_e%t%Y" }}</td>
            <td><a class="term-nav file" href="">.</a></td>
        </tr>
    </nav>
    <nav class="term">
        <tr>
            <td>drwxr-xr-x</td>
            <td class = "term num">32</td>
            <td>eliza</td>
            <td>users</td>
            <td class = "term size">64</td>
            <td>{{ site.time | date: "%b" }}&nbsp;{{ site.time | date: "%_e%t%Y" }}</td>
            <td><a class="term-nav file" href="/index.html">..</a></td>
        </tr>
    </nav>
    {% for item in site.posts %}
    <nav class="term">
    <tr>
        <td>-rw-r--r--</td>
        <td class = "term num">1</td>
        <td>{{ item.author }}</td>
        <td>users</td>
        <td class = "term size">{{ item.content | size }}</td>
        <td>{{ item.date | date: "%b" }}&nbsp;{{ item.date | date: "%_e%t%Y" }}</td>
        <td><a class="term-nav file" href="{{ item.url }}">{{ item.title }}</a></td>
    </tr>
    </nav>
    {% endfor %}
    {% for post in site.data.external-posts %}
    <nav class="term">
    <tr>
        <td>lrwxrwxrwx</td>
        <td class = "term num">1</td>
        <td>eliza</td>
        <td>users</td>
        <td class = "term size">{{ post.size }}</td>
        <td>{{ post.date | date: "%b" }}&nbsp;{{ post.date | date: "%_e%t%Y" }}</td>
        <td><a class="term-nav symlink" href="{{ post.href }}">{{ post.title }}</a></td>
    </tr>
    </nav>
    {% endfor %}
</table>

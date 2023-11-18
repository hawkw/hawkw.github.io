---
layout: dir
title: elizas.website/notes
cmd: "ls -la"
pwd: notes
---

<nav class="term">
    total {{ site.posts.size | plus: site.data.external-posts.size | plus: 2 }}
</nav>
<table class="term">
    <nav class="term">
        <tr>
            <td class = "term ls-la">drwxr-xr-x</td>
            <td class = "term ls-la num">32</td>
            <td class = "term ls-la author">eliza</td>
            <td class = "term ls-la">users</td>
            <td class = "term ls-la size">64</td>
            <td>{{ site.time | date: "%b" }}&nbsp;{{ site.time | date: "%_e%t%Y" }}</td>
            <td><a class="term-nav file" href="">.</a></td>
        </tr>
    </nav>
    <nav class="term">
        <tr>
            <td class = "term ls-la">drwxr-xr-x</td>
            <td class = "term ls-la num">32</td>
            <td class = "term ls-la author">eliza</td>
            <td class = "term ls-la">users</td>
            <td class = "term ls-la size">64</td>
            <td class = "term ls-la date">{{ site.time | date: "%b" }}&nbsp;{{ site.time | date: "%_e%t%Y" }}</td>
            <td><a class="term-nav file" href="/index.html">..</a></td>
        </tr>
    </nav>
    {% for item in site.posts %}
    <nav class="term">
    <tr>
        <td class = "term ls-la">-rw-r--r--</td>
        <td class = "term ls-la num">1</td>
        <td class = "term ls-la author">{{ item.author | split: " " | first | downcase }}</td>
        <td class = "term ls-la">users</td>
        <td class = "term ls-la size">{{ item.content | size }}</td>
        <td class = "term ls-la date">{{ item.date | date: "%b" }}&nbsp;{{ item.date | date: "%_e%t%Y" }}</td>
        <td><a class="term-nav file" href="{{ item.url }}">{{ item.title }}</a></td>
    </tr>
    </nav>
    {% endfor %}
    {% for post in site.data.external-posts %}
    <nav class="term">
    <tr>
        <td class = "term ls-la">lrwxrwxrwx</td>
        <td class = "term ls-la num">1</td>
        <td class = "term ls-la author">eliza</td>
        <td class = "term ls-la">users</td>
        <td class = "term ls-la size">{{ post.size }}</td>
        <td class = "term ls-la date">{{ post.date | date: "%b" }}&nbsp;{{ post.date | date: "%_e%t%Y" }}</td>
        <td><a class="term-nav symlink" href="{{ post.href }}">{{ post.title }}</a></td>
    </tr>
    </nav>
    {% endfor %}
</table>

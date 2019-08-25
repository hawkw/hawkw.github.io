---
layout: dir
title: elizas.website/notes
cmd: "ls -la"
pwd: notes
---

<nav class="term">
    total {{ site.notes.size + 1 }}
</nav>
<table class="term">
    <nav class="term">
        <tr>
            <td>drwxr-xr-x</td>
            <td>32</td>
            <td>eliza</td>
            <td>staff</td>
            <td class = "term size">64</td>
            <td>Aug&nbsp;14&nbsp;2019</td>
            <td><a class="term-nav file" href="">.</a></td>
        </tr>
    </nav>
    <nav class="term">
        <tr>
            <td>drwxr-xr-x</td>
            <td>32</td>
            <td>eliza</td>
            <td>staff</td>
            <td class = "term size">64</td>
            <td>Aug&nbsp;14&nbsp;2019</td>
            <td><a class="term-nav file" href="/index.html">..</a></td>
        </tr>
    </nav>
    {% for item in site.posts %}
    <nav class="term">
    <tr>
        <td>-rw-r--r--</td>
        <td>1</td>
        <td>{{ item.author }}</td>
        <td>staff</td>
        <td class = "term size">{{ item.content | size }}</td>
        <td>{{ item.date | date: "%b" }}&nbsp;{{item.date | date: "%_e%t%Y" }}</td>
        <td><a class="term-nav file" href="{{ item.url }}">{{ item.title }}</a></td>
    </tr>
    </nav>
    {% endfor %}
    <nav class="term">
    <tr>
        <td>-rw-r--r--</td>
        <td>1</td>
        <td>eliza</td>
        <td>staff</td>
        <td class = "term size">26800</td>
        <td>Aug&nbsp;14&nbsp;2019</td>
        <td><a class="term-nav file" href="https://tokio.rs/blog/2019-08-tracing/">Diagnostics with Tracing</a></td>
    </tr>
    </nav>
</table>

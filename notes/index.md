---
layout: dir
title: elizas.website/notes
cmd: "ls -la"
pwd: notes
---

<nav class="term">
    total {{ site.posts.size | plus: 1 }}
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
        <td>{{ item.date | date: "%b" }}&nbsp;{{item.date | date: "%_e%t%Y" }}</td>
        <td><a class="term-nav file" href="{{ item.url }}">{{ item.title }}</a></td>
    </tr>
    </nav>
    {% endfor %}
    <nav class="term">
    <tr>
        <td>-rw-r--r--</td>
        <td class = "term num">1</td>
        <td>eliza</td>
        <td>users</td>
        <td class = "term size">20649</td>
        <td>Jul&nbsp;24&nbsp;2020</td>
        <td><a class="term-nav symlink" href="https://linkerd.io/2020/07/23/under-the-hood-of-linkerds-state-of-the-art-rust-proxy-linkerd2-proxy/">Under the Hood of Linkerd's State-of-the-Art Rust Proxy</a></td>
    </tr>
    </nav>
    <nav class="term">
    <tr>
        <td>-rw-r--r--</td>
        <td class = "term num">1</td>
        <td>eliza</td>
        <td>users</td>
        <td class = "term size">18171</td>
        <td>Dec&nbsp;18&nbsp;2019</td>
        <td><a class="term-nav symlink" href="https://tokio.rs/blog/2019-12-compat/">Announcing Tokio-Compat</a></td>
    </tr>
    </nav>
    <nav class="term">
    <tr>
        <td>-rw-r--r--</td>
        <td class = "term num">1</td>
        <td>eliza</td>
        <td>users</td>
        <td class = "term size">26778</td>
        <td>Aug&nbsp;14&nbsp;2019</td>
        <td><a class="term-nav symlink" href="https://tokio.rs/blog/2019-08-tracing/">Diagnostics with Tracing</a></td>
    </tr>
    </nav>
</table>

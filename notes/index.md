---
layout: dir
title: elizas.website/notes
cmd: "ls -ot"
pwd: notes
---

<nav class="term">
    total {{ site.posts.size + 1 }}
</nav>
<nav class="term">
    drwxr-xr-x&emsp;&emsp;2&emsp;eliza&emsp;&emsp;staff&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;64&emsp;Aug&nbsp;14&nbsp;2019&emsp;
    <a class="term-nav file" href="">.</a>
</nav>
<nav class="term">
    drwxr-xr-x&emsp;32&emsp;eliza&emsp;&emsp;staff&emsp;&emsp;&emsp;&emsp;1024&emsp;Aug&nbsp;14&nbsp;2019&emsp;
    <a class="term-nav file" href="/index.html">..</a>
</nav>
{% for item in site.posts %}
<nav class="term">
    -rw-r--r--&emsp;1&emsp;&emsp;{{ item.author }}&emsp;&emsp;staff&emsp;&emsp;
    {{ item.date | date: "%b" }}&nbsp;{{item.date | date: "%_e%t%Y" }}&emsp;
    <a class="term-nav file" href="{{ item.url }}">{{ item.title }}</a>
</nav>
{% endfor %}
<nav class="term">
    -rw-r--r--&emsp;&emsp;1&emsp;&emsp;eliza&emsp;&emsp;staff&emsp;&emsp;26800&emsp;Aug&nbsp;14&nbsp;2019&emsp;
    <a class="term-nav file" href="https://tokio.rs/blog/2019-08-tracing/">Diagnostics with Tracing</a>
</nav>

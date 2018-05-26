---
layout: dir
title: elizas.website/notes
cmd: "ls -ot"
pwd: notes
---

<nav class="term">
    total {{ site.posts.size }}
</nav>
{% for item in site.posts %}
<nav class="term">
    -rw-r--r--&emsp;1&emsp;&emsp;{{ item.author }}
    {{ item.date | date: "%b" }}&nbsp;{{item.date | date: "%_e%t%Y" }}&emsp;&emsp;
    <a class="term-nav file" href="{{ item.url }}">{{ item.title }}</a>
</nav>
{% endfor %}

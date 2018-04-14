---
layout: dir
title: Notebook
cmd: ls -l
pwd: notes
---

{% for post in site.posts %}
+ {{ post.date | date_to_string }} [ {{ post.title }} ]({{ post.url }})
{% endfor %}

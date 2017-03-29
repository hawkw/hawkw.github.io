---
layout: term
title: Notebook
cmd: cd notes & ls -l
---

{% for post in site.posts %}
+ {{ post.date | date_to_string }} [ {{ post.title }} ]({{ post.url }})
{% endfor %}

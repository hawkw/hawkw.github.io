---
layout: term
title: Notebook
cmd: cd notes & ls -l
---

{% for post in site.posts %} * {{ post.date | date_to_string }} &raquo; [ {{ post.title }} ]({{ post.url }})
{% endfor %}

---
layout: dir
title: elizas.website/slides
cmd: ls -lat
pwd: slides
---

<nav class="term">
    total {{ site.data.slides.size | plus: 2 }}
</nav>
<table class="term">
    <nav class="term">
        <tr class = "mobile-hidden">
            <td class = "term ls-la">drwxr-xr-x</td>
            <td class = "term ls-la num">32</td>
            <td class = "term ls-la author">eliza</td>
            <td class = "term ls-la">users</td>
            <td class = "term ls-la size">64</td>
            <td class = "term ls-la date">{{ site.time | date: "%b" }}&nbsp;{{ site.time | date: "%_e%t%Y" }}</td>
            <td class = "term ls-la"><a class="term-nav file" href="">.</a></td>
        </tr>
    </nav>
    <nav class="term">
        <tr class = "mobile-hidden">
            <td class = "term ls-la">drwxr-xr-x</td>
            <td class = "term ls-la num">32</td>
            <td class = "term ls-la author">eliza</td>
            <td class = "term ls-la">users</td>
            <td class = "term ls-la size">64</td>
            <td class = "term ls-la date">{{ site.time | date: "%b" }}&nbsp;{{ site.time | date: "%_e%t%Y" }}</td>
            <td class = "term ls-la"><a class="term-nav file" href="/index.html">..</a></td>
        </tr>
    </nav>

    {% for item in site.data.slides %}
        {% if item.symlink %}
            <tr>
                <td class = "term ls-la mobile-hidden">lrwxrwxrwx</td>
                <td class = "term ls-la mobile-hidden num">1</td>
                <td class = "term ls-la mobile-hidden author">eliza</td>
                <td class = "term ls-la mobile-hidden">users</td>
                <td class = "term ls-la mobile-hidden size">32</td>
                <td class = "term ls-la date">{{ item.date | date: "%b" }}&nbsp;{{ item.date | date: "%_e%t%Y" }}</td>
                <td><a class="term-nav symlink" href="{{ item.symlink }}">{{ item.title }}.{{ item.extension | default: "mp4" }}</a></td>
            </tr>
        {% endif %}
        {% if item.pdf %}
            <nav class="term">
            <tr>
                <td class = "term ls-la mobile-hidden">-rw-r--r--</td>
                <td class = "term ls-la mobile-hidden num">1</td>
                <td class = "term ls-la mobile-hidden author">eliza</td>
                <td class = "term ls-la mobile-hidden">users</td>
                <td class = "term ls-la mobile-hidden size">{{ item.size }}</td>
                <td class = "term ls-la date {% if item.pdf %}mobile-blank{% endif %}">
                    {{ item.date | date: "%b" }}&nbsp;{{ item.date | date: "%_e%t%Y" }}
                </td>
                <td><a class="term-nav file" href="{{ item.pdf }}">{{ item.title }}.pdf</a></td>
            </tr>
            </nav>
        {% endif %}
    {% endfor %}
</table>

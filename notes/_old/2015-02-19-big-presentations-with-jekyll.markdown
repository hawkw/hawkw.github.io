---
layout: post
title: Big Presentations with Jekyll
categories: projects,programming
---

I have always thought that presentations which accompany talks should be as minimalist as possible, in order to avoid distracting from the speaker. Unless specific graphics, such as diagrams or data visualizations, are to be presented present, I think that the ideal presentation slide should consist of two to five words, at maximum. 

Therefore, I'm a big fan of [Big](https://github.com/tmcw/big), an HTML-based presentation tool written by timcw on Github. Big is a CSS stylesheet and JavaScript script that transform an HTML document into a presentation, with the text typeset as large as possible.

Big is great, but making presentations using Big is less great. Since slides are `<div>`s in an HTML document, each slide or formatted span of text requires writing out HTML tags, which is fairly time consuming. I'd much prefer writing slides the way I write posts for this blog, using Markdown.Also, since Big slides are HTML documents, I've been hosting them on my Web site for a while. I figured, why can't I just have Jekyll format Big presentations, the way it does for the rest of my site?

This morning, I threw together a quick Jekyll template for Big presentations. You can find it on GitHub [here](https://github.com/hawkw/bigyll).

With my template, you can format presentations like this:
{% highlight yaml %}
---
layout: big
title:  "Bigyll example"
sections:
- |
    this slide has *emphasized text*
- | 
    this slide has
    two lines of text
- | 
    this slide has [a link](github.com/hawkw/bigyll)
---
{% endhighlight %}

In my opinion, this is much cleaner and easier than writing the presentation using HTML:
{% highlight html %}
<!DOCTYPE html><html><head><title>Big</title><meta charset='utf-8'><meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0" />
<link href='big.css' rel='stylesheet' type='text/css' />
<script src='big.js'></script></head><body>

<div>this slide has <em>emphasized text</em>/div>
<div>this slide has <br />two lines of text/div>
<div>this slide has <a href="github.com/hawkw/bigyll">a link</a></div>

<script type="text/javascript">
  var _gauges = _gauges || [];
  (function() {
    var t   = document.createElement('script');
    t.type  = 'text/javascript';
    t.async = true;
    t.id    = 'gauges-tracker';
    t.setAttribute('data-site-id', '4e36eb1ef5a1f53d6f000001');
    t.src = '//secure.gaug.es/track.js';
    var s = document.getElementsByTagName('script')[0];
    s.parentNode.insertBefore(t, s);
  })();
</script>

</body>
</html>
{% endhighlight %}

I also wrote Jekyll layouts for @mdnzr's [fork](https://github.com/mdznr/big) of Big, which sizes text using the golden ratio, and @jed's [weenote](https://github.com/jed/weenote), for making [Takahashi](http://en.wikipedia.org/wiki/Takahashi_method)-style presentations. Those layouts can be used instead of the default Big layout.
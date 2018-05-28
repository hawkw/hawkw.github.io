---
layout: post
title:  "Web Apps in Scala"
categories: programming,scala,ideas
---

I've mentioned a number of projects I'm working on here, but one thing I haven't yet taken the time to write is a freelance programming job I've started working on a few weeks ago. I'm writing a web application for tracking inventory and sales data for the garden run by the Environmental Science department on campus.

While I've had some experience with web design with CSS and HTML, and a little interactivity with JavaScript, this project is my first experience working on an interactive web application, so I'm learning a lot. Fortunately, I've found a great frameworks to use in a language I'm already familiar with.

[Scalatra](http://www.scalatra.org) is a simple web server micro-framework for Scala, based on a Ruby framework called [Sinatra](http://sinatrarb.com). There are a number of more well-known web frameworks for Scala, such as [Play](https://www.playframework.com) and [Lift](http://liftweb.net), so what makes Scalatra stand out? 

To me, the greatest thing about Scalatra is its' simplicity. For example, here's a 'hello world' servlet in Scalatra:

{% highlight scala %}
package helloworld
import org.scalatra._

class HelloWorld extends ScalatraFilter {
  get("/") {
    <h1>Hello, world!</h1>
  }
}
{% endhighlight %}

In just seven lines of code, this example creates a servlet that responds to HTTP GET requests to `/` and serves an HTML page containing the phrase "Hello, world!"

Handling other types of HTTP request is possible using the same format. Furthermore, Scalatra allows you to extract parameters from routes, as in the following example (taken from the Scalatra documentation):

{% highlight scala %}
get("/hello/:name") {
  <p>Hello, {params("name")}</p>
}
{% endhighlight %}

In this example, strings are extracted from the URL route and used as parameters in the body. Much more complex routing may be specified using this syntax.

In addition to inline HTML, as seen in the previous two examples, Scalatra has a simple API for handling JSON requests in a web API. If the user is building a web application (like I am), Scalatra supports the [Scalate](http://www.scalatra.org/2.4/guides/views/scalate.html) templating engine, which allows views to be written in a number of templating languages. The one I prefer is based on [Jade](http://jade-lang.com), a JavaScript templating language, but using inline Scala rather than JavaScript.

Scalatra is elegantly minimalist, but it's also very powerful. It provides pretty much all the features I would expect from a web servlet framework, with support for a lot of advanced use-cases I haven't gone into here, but it also makes simple tasks very easy, as the code examples I've presented above have demonstrated.
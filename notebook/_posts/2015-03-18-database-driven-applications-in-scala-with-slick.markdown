---
layout: post
title:  "Database-Driven Applications in Scala with Slick"
categories: programming,scala
---

Another excellent library I'm using in the web application I mentioned in my [previous notebook entry](http://hawkweisman.me/notebook/programming,scala,ideas/2015/02/18/web-apps-in-scala/) is [Slick](http://slick.typesafe.com), a functional-relational mapping library for Scala.

Slick is a database connectivity library which allows a relational database to be queried using similar operations to Scala collections through a process called [lifed embedding](http://slick.typesafe.com/doc/3.0.0-M1/introduction.html#index-6). What this means is that you can use Scala collection methods, like `map`, `fold`, `flatMap`, `exists`, and so forth, on tables in a database, with Slick translating these operations to SQL queries for you. For example:

{% highlight scala %}
sales
  .filter(_.date === date) // get all sale records for today
  .map(_.saleNum) // extract the sale numbers
  .list
  .reduceOption(_ max _)
  .getOrElse(0)
{% endhighlight %}

The following code segment, from my web app, is used to find the highest-numbered sale record in the database for the current day. It's equivalent to the following SQL query:

{% highlight scala %}
"SELECT MAX(saleNum) FROM Sales WHERE date = " + date + ";"
{% endhighlight %}

So why is Slick better? Because instead of building the SQL query through string concatenation, the query is instead represented as method calls on a Scala object. This means the Scala compiler actually understands the query, and can perform semantic analysis (such as type-checking) on it, catching faults at compile-time that might otherwise not be noticed until they cause an error in production.

Slick is a very powerful library with a lot of other useful features I haven't gotten into here, such as code generation for database schemas. Since it's built on top of [JDBC](http://www.oracle.com/technetwork/java/javase/jdbc/index.html), the Java DataBase Connectivity library, it supports pretty much all common relational database management systems, and is compatible with other database-related libraries.
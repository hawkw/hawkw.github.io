---
layout: post
title:  "Building LeJOS EV3 Projects Using Gradle"
categories: robotics,programming,scala,java,tools
---

Lego EV3 robots are often used for teaching robotics, and occasionally in research, as they are inexpensive and easy to reconfigure. For this reason, alternative operating systems for the EV3 exist which allow them to be programmed in a variety of programming languages. In Computer Science 383, we have used robots running the [Lego Java OS](http://www.lejos.org) (LeJOS), which allows the EV3 robot to be programmed using Java.

The LeJOS EV3 library provides plugins for the Eclipse IDE for building Jar files suitble for deployment on the EV3 brick. While the Eclipse plugin for LeJOS is easy to use, it is compatible only with Eclipse. If you prefer to use tools other than Eclipse, building LeJOS code and shipping it to the EV3 can be difficult and time-consuming.

In a recent Computer Science 383 project, my lab partners and I chose to use the [Gradle](http://www.gradle.org) build automation system to build and deploy our programs. Gradle, a popular build system in industry, uses build scripts written using the Groovy programming language. Since  Gradle is highly extensible, configuring it to support EV3 development is not difficult.

Since this information may be useful to others who wish to use Gradle to build LeJOS EV3 programs, I'll provide a brief tutorial on configuring Gradle for this purpose. Elements of this build script are based on the [example project](https://github.com/jornfranke/lejos-ev3-example) published on GitHub by [@jornfranke](https://github.com/jornfranke).

### Adding EV3 Dependencies 

First, in order to compile LeJOS EV3 programs, the LeJOS library files should be placed on the classpath. Typically, the location in which the EV3 libraries are installed is exported as an environment variable, `$EV3_HOME`. This may be added to the Gradle build script's repositories with the following code:

{% highlight groovy %}
repositories {
     flatDir {
       dirs  System.getenv('EV3_HOME') + '/lib/ev3'
   }
}
{% endhighlight %}

Then, Gradle may be configured to enclude the provided dependencies:

{% highlight groovy %}

configurations {
    provided
}


sourceSets {
    main.compileClasspath += configurations.provided
    test.compileClasspath += configurations.provided
    test.runtimeClasspath += configurations.provided
}
{% endhighlight %}

Finally, LeJOS must be added as a dependancy:

{% highlight groovy %}
dependencies {
    provided group: 'lejos', name: 'ev3classes', version: '1.0'
}
{% endhighlight %}

### Configuring JAR Task

EV3 programs are deployed to the robot in the form of Java ARchvie (JAR) files. To compile EV3 JAR files, the following may be added to the build script:

{% highlight groovy %}
jar {
    manifest {
        attributes {
            'Implementation-Title': 'Artificial Bee Colony',
            'Implementation-Version': '1.0', 
            'Main-Class' : 'edu.allegheny.beecolony.Worker'
        }
        from { 
            configurations.compile.collect { 
                it.isDirectory() ? it : zipTree(it) 
                } 
            }
    }
}
{% endhighlight %}

Of course, the manifest attributes such as `'Implementation-Title'` and `'Main-Class'` should be modified to suit the project.

### Deploying

Finally, Gradle may also be used to deploy the JAR files to the EV3 robot automatically. To do so, additional configurations and dependencies must be added:

{% highlight groovy %}
buildscript {
    repositories {
        mavenCentral()
        maven { url "https://oss.sonatype.org/content/groups/public" }
    }
}

configurations {
    sshAntTask
    provided
}

dependencies {
    sshAntTask 'org.apache.ant:ant-jsch:1.9.4', 'jsch:jsch:0.1.29'
    provided group: 'lejos', name: 'ev3classes', version: '1.0'
}
{% endhighlight %}

Then, a new task may be added to deploy the JAR files to the EV3 brick using `scp`:

{% highlight groovy %}
task deployEV3 << {
    ant.taskdef(
        name: 'scp', 
        classname: 'org.apache.tools.ant.taskdefs.optional.ssh.Scp', classpath: configurations.sshAntTask.asPath
        )
    ant.scp(
        todir: ev3_username+'@'+ev3_server+':/home/lejos/programs',
        password: ev3_password,
        verbose: 'true') {
            fileset(dir: './build/libs') {
                include(name: '**/*.jar')
            }
        }
}
{% endhighlight %}

The username and password on the EV3 brick (which are by default set to the empty string), and the robot's IP address, are stored in the project's `gradle.properties` file.
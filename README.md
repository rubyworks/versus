[Homepage](http://rubyworks.github.com/versus) /
[Report Issue](http://github.com/rubyworks/versus) /
[Source Code](http://github.com/rubyworks/versus)
( [![Build Status](https://travis-ci.org/rubyworks/versus.png)](https://travis-ci.org/rubyworks/versus) )


# [Versus](http://rubyworks.github.com/versus)

*A Best-of-Breed Version Class Library*

The Versus gem is a best-of-breed version number class library, providing classes
for a variety of version related requirements.


## [Overview](#overview)

### Version::Number(#number)

The primary class of the Versus gem is the `Version::Number` class. It does
exactly what one would expect, by taking a version literal and giving it a
versitle interface to query and manipulate.

```ruby
    v = Version::Number.new('1.2.0')
    v.major  #=> 1
    v.minor  #=> 2
    v.patch  #=> 0
```

The constructor can also take a tuple and `#[]` is provided as a convenience alias.

```ruby
    v = Version::Number[1,2,0]
```

The Version::Number class has a number of useful methods, such as #satisfy.

```ruby
    v.satisfy?("> 1.0")
```

### [Version::Constraint](#constraint)

Versus also provides a standalone constraint class.

```ruby
    c = Version::Constraint.new("~> 1.2.0")
```

Then versions can be tested against the constraint.

```ruby
    c.satisfy?("1.2.1")
```

### [Version::Resolver](#resolver)

The `Version::Resolver` class is a powerful tool for taking a set of interdpendent
named version requirements and resolving them for the best solution.


### [Version::File](#file)

A `Version::File` class is provided to reading and parsing the typical project VERSION file.



## [Documentation](#documentation)

Versus uses QED to provided tested [demonstrations](http://). This provides a end-user 
acceptance testing while also providing very readable documentation.

For API documentation checkout the YARD generated docs at [RubyDoc.Info](http://rubydoc.info/gems/versus/frames).


## [Copyrights](#copyrights)

Versus is copyrighted open source software.

    Copyright 2011 Rubyworks

Versus can be modified and redistributed in accordance with the
[BSD-2-Clause](http://spdx.org/licenses/bsd-2-clause) License.


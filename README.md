[Homepage](http://rubyworks.github.com/versus) /
[Report Issue](http://github.com/rubyworks/versus) /
[Source Code](http://github.com/rubyworks/versus)
( [![Build Status](https://travis-ci.org/rubyworks/versus.png)](https://travis-ci.org/rubyworks/versus) )


# [Versus](http://rubyworks.github.com/versus)

*A Best-of-Breed Version Class Library*

The Versus gem is a best-of-breed Version class library, providing classes
for a number of version related requirements, form `Version::Number` to
`Version::Resolution`.


## Overview

The primary class of the Versus gem is the `Version::Number` class. It does
exactly what one would expect, by taking a version literal and giving it a
versitle interface to query and manipulate.

```ruby
    v = Version::Number.new('1.2.0')
    v.major  #=> 1
    v.minor  #=> 2
    v.patch  #=> 0
```


## Documentation

Versus uses QED to provided tested [demonstrations](http://). This provides a end-user 
acceptance testing while also providing very readable documentation.

For API documentation checkout the YARD generated docs at [RubyDoc.Info](http://rubydoc.info/gems/versus/frames).


## Copyrights

Versus is copyrighted open source software.

    Copyright 2011 Rubyworks

Versus can be modified and redistributed in accordance with the
[BSD-2-Clause](http://spdx.org/licenses/bsd-2-clause) License.


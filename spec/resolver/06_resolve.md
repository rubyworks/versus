# Version::Resolver#resolve

Given a Resolver and a set of entries,

    resolver = Version::Resolver.new

    resolver.add('foo', '1.0.0', 'bar'=>'> 1.0')
    resolver.add('bar', '1.0.0')
    resolver.add('bar', '2.0.0')

We can resolve the requirements

    result = resolver.resolve('foo', '1.0.0')

    result.assert == {'foo'=>Version['1.0.0'], 'bar'=>Version['2.0.0']}

If there are not sufficient requirements then no resolution will be returned.

    resolver = Version::Resolver.new

    resolver.add('foo', '1.0.0', 'bar'=>'> 1.0')
    resolver.add('bar', '1.0.0')

    result = resolver.resolve('foo', '1.0.0')

    result.assert == nil

Let try a more complex example to be sure of our algorithm.

    resolver.add('foo', '1.0.0', 'bar'=>'> 1.0', 'baz'=>'> 2.0')
    resolver.add('bar', '1.0.0', 'baz'=>'= 3.1')
    resolver.add('bar', '2.0.0', 'baz'=>'= 3.1')
    resolver.add('baz', '2.9.0')
    resolver.add('baz', '3.1.0')
    resolver.add('baz', '3.2.0')

    result = resolver.resolve('foo', '1.0.0')

    result.assert == { 'foo'=>Version['1.0.0'],
                       'bar'=>Version['2.0.0'],
                       'baz'=>Version['3.1.0'] }


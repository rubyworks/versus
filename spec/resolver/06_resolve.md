# Version::Resolver#resolve

given a set of entries.

    resolver = Version::Resolver.new

    resolver.add('foo', '1.0.0', 'bar'=>'> 1.0')
    resolver.add('bar', '1.0.0')
    resolver.add('bar', '2.0.0')

We can resolve the requirements

    result = resolver.resolve('foo', '1.0.0')

    p result



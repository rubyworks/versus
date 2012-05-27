# Version::Resolver#possibilities

Requiremnets can be looked-up using the `#requirements` method.

    resolver = Version::Resolver.new

    resolver.add('foo', '1.0.0', 'bar'=>'> 1.0')
    resolver.add('bar', '2.0.0')

    potents = resolver.possibilities('foo', '= 1.0.0')

    potents.first.first.assert == 'foo'


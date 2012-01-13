# Version::Resolver#requirements

Requiremnets can be looked-up using the `#requirements` method.

    resolver = Version::Resolver.new

    resolver.add('foo', '1.0.0', 'bar'=>'> 1.0')
    resolver.add('bar', '2.0.0')

    requires = resolver.requirements('foo', '1.0.0')

    requires.keys.assert == ['bar']


# Version::Resolver#libraries

Adding entries to the Resolver build up a map of "libraries".

    resolver = Version::Resolver.new

    resolver.add('foo', '1.0.0', 'bar'=>'> 1.0')
    resolver.add('bar', '2.0.0')

    resolver.libraries.assert.is_a?(Hash)

The hash is made up of the libraries added to the reolver, just organized
into two-tier hash of `name => version-number => requirements`.

    resolver.libraries['foo'].assert.is_a?(Hash)

But the version has version-number is converted into a Version::Number 
instance, and the requirement's version constraint is converted into
a Version::Constraint instance.

    version = Version::Number.parse('1.0.0')

    resolver.libraries['foo'][version].assert.is_a?(Hash)


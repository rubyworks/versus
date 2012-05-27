# Version::Resolver.add

Rather then passing dependencies to the constructor, a Resolver can be
initialized without arguments and then passed dependencies one at a time
using the `#add` method.

    resolver = Version::Resolver.new

    resolver.add('foo', '1.0.0', 'bar'=>'> 1.0')
    resolver.add('bar', '2.0.0')


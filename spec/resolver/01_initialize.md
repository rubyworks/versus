# Version::Resolver#initialize

The Resolver class provides a means for resolving versioned 

  resolver = Version::Resolver.new

A new Resolver can take a list of dependent entries. These are supplied as
a list of three-element arrays containing name, version number and requiremnets.
Where requirements are themselves a list of names and version constraints.

  resolver = Version::Resolver.new(
    ['foo', '1.0.0', {'bar' => '> 1.0'}],
    ['bar', '2.0.0', {}]
  )

If the requirements list is left out of an entry, it should still initialize
without issue.

  resolver = Version::Resolver.new(
    ['foo', '1.0.0', {'bar' => '> 1.0'}],
    ['bar', '2.0.0']
  )


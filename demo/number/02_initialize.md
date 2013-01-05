## Version::Number#initialize

A version number is composed of segments.

    v = Version::Number.new(1,2,3,'alpha',4)

There a few alternative initializers. The most consice is [].

    v = Version::Number[1,2,3,'beta',4]

The #new constructor can also take a string representation of the version.

    v = Version::Number.new('1.2.3rc1')


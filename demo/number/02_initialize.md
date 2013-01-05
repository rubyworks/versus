## Version::Number#initialize

A version number is composed of segments.

    v = Version::Number.new(1,2,3,'alpha',4)

There a few alternative initializers. The most consice is [].

    v = Version::Number[1,2,3,'beta',4]

There is also `parse` which takes a single string argument.

    v = Version::Number.parse('1.2.3rc1')



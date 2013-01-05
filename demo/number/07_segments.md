## Version::Number Segments

A version number is divided up into segements, or *points*.
Some of the points have names. THe first three are widely known
as the *major*, *minor* and *patch* numbers, respectively.

    v = Version::Number[1,2,3]

    v.major.assert == 1
    v.minor.assert == 2
    v.patch.assert == 3
  
The Version::Number class also recognizes state, or status.

    v = Version::Number[1,2,3,'beta',4]

    v.state.assert  == 'beta'
    v.status.assert == 'beta'

From the state on is considered the *build* portion of the version.

    v.build.assert == 'beta.4'

The *build number* is the number directly following the state.

    v.build_number.assert == 4

While it is not recommended, technically the Version::Number class
can handle an arbitrarily long tuple.

    v = Version::Number[1,2,3,4,5,6,'beta',7]

    v.major.assert == 1
    v.minor.assert == 2
    v.patch.assert == 3

    v.state.assert == 'beta'

However, there are no recognized names for the segments between
the third, patch entry and the state entry.

Short version can also be used.

    v = Version::Number[1,'rc',7]

    v.major.assert == 1
    v.minor.assert == nil
    v.patch.assert == nil

    v.state.assert == 'rc'


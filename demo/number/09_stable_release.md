## Version::Number#stable?

The `stable?` method returns `true` if the build is `nil`,
otherwise `false`.

    v = Version::Number[1,2,3]

    v.assert.stable?

    v = Version::Number[1,2,3,'pre',4]

    v.refute.stable?


## Version::Number#stable_release?

    v = Version::Number[1,2,3]

    v.assert.stable_release?

    v = Version::Number[1,2,3,'pre',4]

    v.refute.stable_release?

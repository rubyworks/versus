## Version::Number#stable?

The `stable?` method returns `true` if the build is `nil`,
otherwise `false`.

    v = DotRuby::Version::Number[1,2,3]

    v.assert.stable?

    v = DotRuby::Version::Number[1,2,3,'pre',4]

    v.refute.stable?


## Version::Number#stable_release?

    v = DotRuby::Version::Number[1,2,3]

    v.assert.stable_release?

    v = DotRuby::Version::Number[1,2,3,'pre',4]

    v.refute.stable_release?

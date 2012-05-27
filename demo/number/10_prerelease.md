## Version::Number#prerelease?

The `prerelease?` method returns `true` if the build is `pre`,
otherwise `false`.

    v = DotRuby::Version::Number[1,2,3,'pre',4]

    v.assert.prerelease?


    v = DotRuby::Version::Number[1,2,3]

    v.refute.prerelease?


    v = DotRuby::Version::Number[1,2,3,'alpha']

    v.refute.prerelease?


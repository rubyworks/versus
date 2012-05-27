## Version::Number#release_candidate?

The `release_candidate?` method returns `true` if the build
is `rc`, otherwise `false`.

    check do |v|
      v = DotRuby::Version::Number.parse(v)
      v.release_candidate?
    end

    ok [1,2,3,'rc',1]
    no [1,2,3]
    no [1,2,3,'alpha']



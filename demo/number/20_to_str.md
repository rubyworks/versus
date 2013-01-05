## Version::Number#to_str

The Version::Number class can be thought of as a String.

    check do |v, s|
      v = Version::Number.parse(v)
      v.to_str.assert == s
    end

    ok [1,2,3],         '1.2.3'
    ok [1,2,3,'rc',1],  '1.2.3.rc.1'
    ok [1,2,3,'alpha'], '1.2.3.alpha'


## Version::Number#<=>

The inclusion of Comparable mixin into the Version class
along with the definition of #<=>, provides the class with
all the common inequality methods.

### Equality

    check do |n1, n2|
      v1 = DotRuby::Version::Number.parse(n1)
      v2 = DotRuby::Version::Number.parse(n2)
      v1.should == v2
    end

    ok  '1.0.0', '1.0.0'
    ok  '1.0.0', '1.0'

### Greater-Than

    check do |n1, n2|
      v1 = DotRuby::Version::Number.parse(n1)
      v2 = DotRuby::Version::Number.parse(n2)
      v1.should > v2
    end

    ok '1.0.1', '1.0.0'
    ok '1.1.0', '1.0.0'
    ok '2.0.0', '1.0.0'
    ok '1.1',   '1.0.0'
    ok '1.0.0', '1.0.0.rc.3'

    no '1.0.0', '1.0.0'

### Less-Than

    check do |n1, n2|
      v1 = DotRuby::Version::Number.parse(n1)
      v2 = DotRuby::Version::Number.parse(n2)
      v1.should < v2
    end

    ok '1.0.1', '1.0.2'
    ok '1.1.0', '1.2.0'
    ok '2.0.0', '2.1.0'
    ok '1.2.3', '2.0.0'
    ok '1.2.3', '2.0'
    ok '1.1',   '1.2.0'
    ok '1.0.0.rc.2', '1.0.0'

    no '1.0.0', '1.0.0'

### Greater-Than-Or-Equal

    check do |n1, n2|
      v1 = DotRuby::Version::Number.parse(n1)
      v2 = DotRuby::Version::Number.parse(n2)
      v1.should >= v2
    end

    ok '1.0.1', '1.0.0'
    ok '1.1.0', '1.0.0'
    ok '2.0.0', '1.0.0'
    ok '1.1',   '1.0.0'
    ok '1.0.0', '1.0.0.rc.3'
    ok '1.0.0', '1.0.0'

### Less-Than-Or-Equal

    check do |n1, n2|
      v1 = DotRuby::Version::Number.parse(n1)
      v2 = DotRuby::Version::Number.parse(n2)
      v1.should <= v2
    end

    ok '1.0.1', '1.0.2'
    ok '1.1.0', '1.2.0'
    ok '2.0.0', '2.1.0'
    ok '1.1',   '1.2.0'
    ok '1.0.0.rc.2', '1.0.0'
    ok '1.0.0', '1.0.0'

### Approximate Constraint

    check do |n1, n2|
      v1 = DotRuby::Version::Number.parse(n1)
      v2 = DotRuby::Version::Number.parse(n2)
      v1.should =~ v2
    end

    ok '1.0.0', '1.0'
    ok '1.0.2', '1.0'
    ok '2.1.1', '2.1'

    no '1.1.0', '1.2.0'
    no '1.1.0', '2.0'

    # TODO: Should this be ok ?
    no '1.0.0.rc.2', '1.0'


## Version::Number#build

The `build` method ...

    v = Version::Number[1,2,3]

    v.build.should == nil


    v = Version::Number[1,2,3,'pre']

    v.build.should == 'pre'


    v = Version::Number[1,2,3,'pre',2]

    v.build.should == 'pre.2'


    v = Version::Number[1,2,3,'20101020']

    v.build.should == '20101020'


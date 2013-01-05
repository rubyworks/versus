## Version#to_gem_version

Since RubyGems supporst a more limited version constrain format, the
Constraint class provides the `#to_gem_version` method to produce
a string representation of the constraint that RubyGems can understand.

    version = Version::Constraint.parse('1.2~')

    version.to_gem_version.should == "~> 1.2"


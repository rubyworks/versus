## Version::Constraint#initialize

The Constraint class models a single version equality
or inequality. It consists of the operator and the version
number.

    c = DotRuby::Version::Constraint.new(['>=', '1.0'])

    c.operator == '>='
    c.number   == '1.0'

### Using []

    c = DotRuby::Version::Constraint['>=', '1.0']

    c.operator == '>='
    c.number   == '1.0'

### String Parsing

The constraint constructor can also parse strings.

    check do |mp|
      mp.each do |str, (op, num)|
        c = DotRuby::Version::Constraint.new(str)
        c.operator.should    == op
        c.number.to_s.should == num
      end
    end

    ok '1.2.3'    => ['==', '1.2.3']
    ok '= 4.6.2'  => ['==', '4.6.2']
    ok '== 5.1.1' => ['==', '5.1.1']
    ok '>= 2.3.4' => ['>=', '2.3.4']
    ok '> 3.4.5'  => ['>',  '3.4.5']
    ok '<= 2.3.4' => ['<=', '2.3.4']
    ok '< 3.4.5'  => ['<',  '3.4.5']

Suffix notations are also parsable.

    ok '1.2+'     => ['>=', '1.2']
    ok '1.3-'     => ['<' , '1.3']
    ok '2.8~'     => ['=~', '2.8']


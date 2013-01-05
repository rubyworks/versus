## Version::Number#bump

A version number can be *bumped*, which means various segments
can be incremented. Bumping is handled by the #bump method which
is passed a symbol describing the type of bump to effect.

### Bump major number

    v = Version::Number[1,0,0]
    v.bump(:major).to_s == '2.0.0'

### Bump minor number

    v = Version::Number[1,0,0]
    v.bump(:minor).to_s == '1.1.0'

### Bump patch number

    v = Version::Number[1,0,0]
    v.bump(:patch).to_s == '1.0.1'

### Bump build number

    v = Version::Number[1,0,0,0]
    v.bump(:build).to_s == '1.0.0.1'

### Bump build number with state

    v = Version::Number[1,0,0,'pre',1]
    v.bump(:build).to_s == '1.0.0.pre.2'

### Bump state segment

    v = Version::Number[1,0,0,'pre',2]
    v.bump(:state).to_s == '1.0.0.rc.1'

### Bump last segment

    v = Version::Number[1,0,0,'pre',3]
    v.bump(:last).to_s == '1.0.0.pre.4'

### Reset State

    v = Version::Number[1,0,0,'pre',2]
    v.restate(:beta).to_s == '1.0.0.beta.1' 


## Version::Number#match?

The `match?` method

    v = DotRuby::Version::Number[1,2,3]

    v.assert.match?('> 1.2')
    v.assert.match?('< 2.0')
    v.assert.match?('> 1.2', '< 2.0')


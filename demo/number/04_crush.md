## Version::Number#crush?

A version can be represented as a string in one of two ways --either
as a strict point seprated tuple or *crushed* where string segements
are merged with the following numerical segement.

The Version::Number class will automatically reqcognize a *crushed*
version if a segment of the version tuple is provided as such.

    v = Version::Number.new(1,2,3,'alpha4')

    v.assert.crush?

The output result of a crushed version.

    v.to_s.assert == '1.2.3alpha4'


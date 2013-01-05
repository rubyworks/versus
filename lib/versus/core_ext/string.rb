require 'versus'

class String
  #
  # Converts the String into a version number.
  #
  def to_version
    Version::Number.parse(self)
  end
end

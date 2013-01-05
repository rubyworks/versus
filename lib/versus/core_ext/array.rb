require 'version'

class Array
  #
  # Converts the Array into a version number.
  #
  def to_version
    Version::Number.new(*self)
  end
end


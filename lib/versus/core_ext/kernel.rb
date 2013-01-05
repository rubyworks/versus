module Kernel
private

  #
  # If an arbitrary object need to be converted to a `Version::Number`, this is
  # a good way to do it.
  #
  # The capitalize method follows the Ruby conventions of `Array()` and `String()`, 
  # etc. Though in this case `Version()` actually creates a `Version::Number` object,
  # that is far an away the typical use case for the Version module.
  #
  def Version(version)
    Version::Number.parse(version)
  end

end


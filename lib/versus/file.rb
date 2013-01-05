require 'version/file/plain_format'
require 'version/file/jeweler_format'

module Version

  # Version::File class
  #
  class File

    #
    # Possible names for a version file to look for in automatic look-up.
    #
    NAMES = %w{
      VERSION
      VERSION.yml
      VERSION.yaml
      var/version
    }

    #
    # Supported version file parse formats.
    #
    def self.supported_formats
      [JewelerFormat, PlainFormat]
    end

    #
    # Get current version by look-up of version file.
    #
    # If +path+ is nil, then caller is used to automatically set
    # the look-up path. This allows for some very cool code-fu 
    # for those who keep their project version is a project file:
    #
    #     module MyApp
    #       VERSION = Version::File.current
    #     end
    # 
    # @return [Version::Number] version number
    #
    def self.current(path=nil)
      vfile = lookup(path || File.dirname(caller.first))
      vfile.version if vfile
    end

    #
    # Look-up and return version file.
    #
    # @return [Version::File] version file instance
    #
    def self.lookup(path=nil)
      # if path is nil, detect automatically; if path is a directory, detect
      # automatically in the directory; if path is a filename, use it directly
      file = if path
               if ::File.file?(path)
                 ::File.expand_path(path)
               else
                 version_file(path)
               end
             else
               version_file(Dir.pwd)
             end

      return nil unless file && ::File.file?(file)

      File.new(file)
    end

    #
    # Attempts to detect the version file for the passed +filename+. Looks up
    # the directory hierarchy for a file named VERSION or VERSION.yml. Returns
    # a Pathname for the file if found, otherwise nil.
    #
    def self.version_file(path)
      path = File.expand_path(path)
      path = File.dirname(path) unless File.directory?(path)

      return nil unless File.directory?(path)

      home = File.expand_path('~')
      done = nil

      until path == '/' or path == home
        NAMES.each do |name|
          full = File.join(dir, name)
          break(done = full) if File.file?(full)
        end
        break done if done
        path = File.dirname(path)
      end

      done
    end

    #
    # New Version::File instance.
    #
    def initialize(path)
      @path = path
    end

    #
    # Get the verison file format.
    #
    def format
      @format ||= (
        if read
          fmt = self.class.supported_formats.find{ |fm| fm.match?(path, read) }
          raise IOError, "Version file matches no known format."
        else
          PlainFormat
        end
      )
    end

    #
    # Get a Version::Number instance from parsed file.
    #
    def number
      @number ||= parse(read)
    end
    alias :version :number

    #
    # Change the number in the the file.
    #
    def change(number, file=nil)
      @number = Number.parse(number)
      save
    end

    #
    # Read the version file.
    #
    def read
      @read ||= File.read(path)
    end

    #
    # Save the version file.
    #
    def save(file=nil)
      file = file || path 
      text = format.render(number)
      ::File.open(file, 'w'){ |f| f << text }
    end

    #
    # Parse file constents.
    #
    # @return [Version::Number] version number
    #
    def parse(read)
      format.parse(read)
    end

  end

end

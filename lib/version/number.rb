module DotRuby

  module Version

    # Represents a versiou number. Developer SHOULD use three point 
    # SemVer standard, but this class is mildly flexible in it's support
    # for variations.
    #
    # @see http://semver.org/
    #
    class Number
      include Enumerable
      include Comparable

      # Recognized build states in order of completion.
      # This is only used when by #bump_state.
      STATES = ['alpha', 'beta', 'pre', 'rc']

      #
      # Creates a new version.
      #
      # @param points [Array] version points
      #
      def initialize(*points)
        @crush = false
        points.map! do |point|
          sane_point(point)
        end
        @tuple = points.flatten.compact
      end

      # Shortcut for creating a new verison number
      # given segmented elements.
      #
      #   VersionNumber[1,0,0].to_s
      #   #=> "1.0.0"
      #
      #   VersionNumber[1,0,0,:pre,2].to_s
      #   #=> "1.0.0.pre.2"
      #
      def self.[](*args)
        new(*args)
      end

      #
      # Parses a version string.
      #
      # @param [String] string
      #   The version string.
      #
      # @return [Version]
      #   The parsed version.
      #
      def self.parse(version)
        case version
        when String
          new(*version.split('.'))
        when Number #self.class
          new(*version.to_a)
        else
          new(*version.to_ary)  #to_a) ?
        end
      end

      #
      def self.cmp(version1, version2)
        # TODO: class level compare might be handy
      end

      # Major version number
      def major
        (state_index && state_index == 0) ? nil : self[0]
      end

      # Minor version number
      def minor
        (state_index && state_index <= 1) ? nil : self[1]
      end

      # Patch version number
      def patch
        (state_index && state_index <= 2) ? nil : self[2]
      end

      # The build.
      def build
        if b = state_index
          str = @tuple[b..-1].join('.')
          str = crush_point(str) if crush?
          str
        elsif @tuple[3].nil?
          nil
        else
          str = @tuple[3..-1].join('.')
          str = crush_point(str) if crush?
          str
        end
      end

      #
      def state
        state_index ? @tuple[state_index] : nil
      end

      #
      alias status state

      # Return the state revision count. This is the
      # number that occurs after the state.
      #
      #   Version::Number[1,2,0,:rc,4].build_number
      #   #=> 4
      #
      def build_number #revision
        if i = state_index
          self[i+1] || 0
        else
          nil
        end
      end

      # @param [Integer] major
      #   The major version number.
      def major=(number)
        @tuple[0] = number.to_i
      end

      # @param [Integer, nil] minor
      #   The minor version number.
      def minor=(number)
        @tuple[1] = number.to_i
      end

      # @param [Integer, nil] patch
      #   The patch version number.
      def patch=(number)
        @tuple[2] = number.to_i
      end

      # @param [Integer, nil] build (nil)
      #   The build version number.
      def build=(point)
        @tuple = @tuple[0...state_index] + sane_point(point)
      end

      #
      def stable?
        build.nil?
      end

      alias_method :stable_release?, :stable?

      #
      def alpha?
        s = status.dowcase
        s == 'alpha' or s == 'a'
      end

      #
      def beta?
        s = status.dowcase
        s == 'beta' or s == 'b'
      end

      #
      def prerelease?
        status == 'pre'
      end

      #
      def release_candidate?
        status == 'rc'
      end

      # Fetch a sepecific segement by index number.
      # In no value is found at that position than
      # zero (0) is returned instead.
      #
      #   v = Version::Number[1,2,0]
      #   v[0]  #=> 1
      #   v[1]  #=> 2
      #   v[3]  #=> 0
      #   v[4]  #=> 0
      #
      # Zero is returned instead of +nil+ to make different
      # version numbers easier to compare.
      def [](index)
        @tuple.fetch(index,0)
      end

      # Returns a duplicate of the underlying version tuple.
      #
      def to_a
        @tuple.dup
      end

      # Converts version to a dot-separated string.
      #
      #   Version::Number[1,2,0].to_s
      #   #=> "1.2.0"
      #
      # TODO: crush
      def to_s         
        str = @tuple.compact.join('.')
        str = crush_point(str) if crush?
        return str
      end

      # This method is the same as #to_s. It is here becuase
      # `File.join` calls it instead of #to_s.
      #
      #   VersionNumber[1,2,0].to_str
      #   #=> "1.2.0"
      #
      def to_str
        to_s
      end

      # Returns a String detaling the version number.
      # Essentially it is the same as #to_s.
      #
      #   VersionNumber[1,2,0].inspect
      #   #=> "1.2.0"
      #
      def inspect
        to_s
      end

      #
      # Converts the version to YAML.
      #
      # @param [Hash] opts
      #   Options supporte by YAML.
      #
      # @return [String]
      #   The resulting YAML.
      #
      #--
      # TODO: Should this be here?
      #++
      def to_yaml(opts={})
        to_s.to_yaml(opts)
      end

      #
      #def ==(other)
      #  (self <=> other) == 0
      #end

      # Compare versions.
      def <=>(other)
        [@tuple.size, other.size].max.times do |i|
          p1, p2 = (@tuple[i] || 0), (other[i] || 0)
          # this is bit tricky, basically a string < integer.
          if p1.class != p2.class
            cmp = p2.to_s <=> p1.to_s
          else
            cmp = p1 <=> p2
          end
          return cmp unless cmp == 0
        end
        #(@tuple.size <=> other.size) * -1
        return 0
      end

      # For pessimistic constraint (like '~>' in gems).
      #
      # FIXME: Ensure it can handle trailing state.
      def =~(other)
        upver = other.bump(:last)
        #@segments >= other and @segments < upver
        self >= other and self < upver
      end

      # Iterate of each segment of the version. This allows
      # all enumerable methods to be used.
      #
      #   Version::Number[1,2,3].map{|i| i + 1}
      #   #=> [2,3,4]
      #
      # Though keep in mind that the state segment is not
      # a number (and techincally any segment can be a string
      # instead of an integer).
      def each(&block)
        @tuple.each(&block)
      end

      # Return the number of version segements.
      #
      #   Version::Number[1,2,3].size
      #   #=> 3
      #
      def size
        @tuple.size
      end

      # Bump the version returning a new version number object.
      # Select +which+ segement to bump by name: +major+, +minor+,
      # +patch+, +state+, +build+ and also +last+.
      #
      #   Version::Number[1,2,0].bump(:patch).to_s
      #   #=> "1.2.1"
      #
      #   Version::Number[1,2,1].bump(:minor).to_s
      #   #=> "1.3.0"
      #
      #   Version::Number[1,3,0].bump(:major).to_s
      #   #=> "2.0.0"
      #
      #   Version::Number[1,3,0,:pre,1].bump(:build).to_s
      #   #=> "1.3.0.pre.2"
      #
      #   Version::Number[1,3,0,:pre,2].bump(:state).to_s
      #   #=> "1.3.0.rc.1"
      #
      def bump(which=:patch)
        case which.to_sym
        when :major, :first
          bump_major
        when :minor
          bump_minor
        when :patch
          bump_patch
        when :state, :status
          bump_state
        when :build
          bump_build
        when :revision
          bump_revision
        when :last
          bump_last
        else
          self.class.new(@tuple.dup.compact)
        end
      end

      #
      def bump_major
        self.class[inc(major), 0, 0]
      end

      #
      def bump_minor
        self.class[major, inc(minor), 0]
      end

      #
      def bump_patch
        self.class[major, minor, inc(patch)]
      end

      #
      def bump_state
        if i = state_index
          if n = inc(@tuple[i])
            v = @tuple[0...i] + [n] + (@tuple[i+1] ? [1] : [])
          else
            v = @tuple[0...i]
          end
        else
          v = @tuple.dup
        end
        self.class.new(v.compact)
      end

      #
      alias :bump_status :bump_state

      #
      def bump_build
        if i = state_index
          if i == @tuple.size - 1
            v = @tuple + [1]
          else
            v = @tuple[0...-1] + [inc(@tuple.last)]
          end
        else
          if @tuple.size <= 3
            v = @tuple + [1]
          else
            v = @tuple[0...-1] + [inc(@tuple.last)]
          end
        end
        self.class.new(v.compact)
      end

      #
      def bump_build_number #revision
        if i = state_index
          v = @tuple[0...-1] + [inc(@tuple.last)]
        else
          v = @tuple[0..2] + ['alpha', 1]
        end
        self.class.new(v.compact)
      end

      #
      def bump_last
        v = @tuple[0...-1] + [inc(@tuple.last)]
        self.class.new(v.compact)
      end

      # Return a new version have the same major, minor and
      # patch levels, but with a new state and revision count.
      #
      #   Version::Number[1,2,3].restate(:pre,2).to_s
      #   #=> "1.2.3.pre.2"
      #
      #   Version::Number[1,2,3,:pre,2].restate(:rc,4).to_s
      #   #=> "1.2.3.rc.4"
      #
      def restate(state, revision=1)
        if i = state_index
          v = @tuple[0...i] + [state.to_s] + [revision]
        else
          v = @tuple[0...3] + [state.to_s] + [revision]
        end
        self.class.new(v)
      end

      # Does the version string representation compact
      # string segments with the subsequent number segement?
      def crush?
        @crush
      end

      # Does this version match a given constraint? The constraint is a String
      # in the form of "{operator} {version number}".
      #--
      # TODO: match? will change as Constraint class is improved.
      #++
      def match?(*constraints)
        constraints.all? do |c|
          Constraint.constraint_lambda(c).call(self)
        end
      end

      protected

      # Return the undelying segments array.
      attr :tuple

      private

      # Convert a segment into an integer or string.
      def sane_point(point)      
        point = point.to_s if Symbol === point
        case point
        when Integer
          point
        when /^\d+$/
          point.to_i
        when /^(\d+)(\w+)(\d+)$/
          @crush = true
          [$1.to_i, $2, $3.to_i]
        when /^(\w+)(\d+)$/
          @crush = true
          [$1, $2.to_i]
        else
          point
        end
      end

      # Take a point string rendering of a version and crush it!
      def crush_point(string)
        string.gsub(/(^|\.)(\D+)\.(\d+)(\.|$)/, '\2\3')
      end

      # Return the index of the first recognized state.
      #
      #   VersionNumber[1,2,3,'pre',3].state_index
      #   #=> 3
      #
      # You might ask why this is needed, since the state
      # position should always be 3. However, there isn't 
      # always a state entry, which means this method will
      # return +nil+, and we also leave open the potential
      # for extra-long version numbers --though we do not
      # recommend the idea, it is possible.
      def state_index
        @tuple.index{ |s| String === s }
      end

      # Segement incrementor.
      def inc(val)
        if i = STATES.index(val.to_s)
          STATES[i+1]
        else
          val.succ
        end
      end

    end
  end
end

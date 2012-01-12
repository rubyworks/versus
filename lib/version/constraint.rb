module DotRuby

  module Version

    # The Constraint class models a single version equality or inequality.
    # It consists of the operator and the version number.
    #--
    # TODO: Please improve me!
    #
    # TODO: This should ultimately replace the class methods of Version::Number.
    #
    # TODO: Do we need to support version "from-to" spans ?
    #++
    class Constraint

      #
      def self.parse(constraint)
        new(constraint)
      end

      #
      def self.[](operator, number)
        new([operator, number])
      end

      #
      def initialize(constraint)
        @operator, @number = parse(constraint || '0+')

        case constraint
        when Array
          @stamp = "%s %s" % [@operator, @number]
        when String
          @stamp = constraint || '0+'
        end
      end

      # Constraint operator.
      attr :operator

      # Verison number.
      attr :number

      #
      def to_s
        @stamp
      end

      # Converts the version into a constraint string recognizable
      # by RubyGems.
      #--
      # TODO: Better name Constraint#to_s2.
      #++
      def to_gem_version
        op = (operator == '=~' ? '~>' : operator)
        "%s %s" % [op, number]
      end

      #
      # Convert constraint to Proc object which can be
      # used to test a version number.
      #
      def to_proc
        lambda do |v|
          n = Version::Number.parse(v)
          n.send(operator, number)
        end
      end

      #
      def call(v)
        n = Version::Number.parse(v)
        n.send(operator, number)
      end

      # better name?
      alias :fits? :call

    private

      #
      def parse(constraint)
        case constraint
        when Array
          op, num = constraint
        when /^(.*?)\~$/
          op, val = "=~", $1
        when /^(.*?)\+$/
          op, val = ">=", $1
        when /^(.*?)\-$/
          op, val = "<", $1
        when /^(=~|~>|<=|>=|==|=|<|>)?\s*(\d+(:?[-.]\w+)*)$/
          if op = $1
            op = '=~' if op == '~>'
            op = '==' if op == '='
            val = $2.split(/\W+/)
          else
            op = '=='
            val = constraint.split(/\W+/)
          end
        else
          raise ArgumentError #constraint.split(/\s+/)
        end
        return op, Version::Number.new(*val)
      end

      # Parse package entry into name and version constraint.
      #def parse(package)
      #  parts = package.strip.split(/\s+/)
      #  name = parts.shift
      #  vers = parts.empty? ? nil : parts.join(' ')
      # [name, vers]
      #end

    public

      # Parses a string constraint returning the operation as a lambda.
      def self.constraint_lambda(constraint)
        new(constraint).to_proc
      end

      # Parses a string constraint returning the operator and value.
      def self.parse_constraint(constraint)
        c = new(constraint)
        return c.operator, c.number
      end

    end

  end

end

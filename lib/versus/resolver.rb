module Version

  # Version resolution takes a requirements list and can reduce it
  # to a best fit list.
  #
  class Resolver

    #
    # Initialize new Resolver.
    #
    # @param [Array] available
    #   List of name, version and requirements for each possible library.
    #
    def initialize(*available)
      @libraries = Hash.new{ |h,k| h[k] = {} }

      available.each do |name, version, requirements|
        add(name, version, requirements || {})
      end
    end

    #
    # Map of dependencies by name and version to requirements.
    #
    attr :libraries

    #
    # List of library names and versions of failed resolutions
    # subsequent to calling `#resolve`.
    #
    #attr :failures

    #
    # Add available library.
    #
    # @param [String] name
    #   The name of the library.
    #
    # @param [String,Version::Number] version
    #   Version number of library.
    #
    # @param [Hash] requirements
    #   Requirements for the library in the form of `{name=>version_constraint}`.
    #
    def add(name, version, requirements={})
      name     = name.to_s
      number   = Number.parse(version)
      requires = {}

      requirements.each do |n,c|
        requires[n.to_s] = Constraint.parse(c)
      end

      @libraries[name][number] = requires
    end

    #
    # Look-up requirements for a given name and version.
    #
    def requirements(name, number)
      number = Version::Number.parse(number) #unless Version::Number === number
      @libraries[name][number]
    end

    #
    # Returns possibilities sorted in descending order.
    #
    def possibilities(name, constraint)
      name       = name.to_s
      constraint = Constraint.parse(constraint)

      list = []
      @libraries[name].each do |version, _|
        if constraint.match?(version)
          list << [name, version]
        end
      end

      list.sort!{ |a,b| b[1] <=> a[1] }
    end

    #
    # TODO: support resolution of multiple [name, versions] at once.
    #
    def resolve(name, number)
      name   = name.to_s
      number = Number.parse(number)

      @cache    = {}
      @failures = []

      sheet = {}

      result = resolve_(name, number, sheet)

      #list.each do |name, version|
      #  name   = name.to_s
      #  number = Number.parse(version)
      #
      #  resolve_(name, number, sheet)
      #end
      result ? sheet : nil
    end

    #
    # Returns a mapping of unresolvable requirements. The key of the Hash is the 
    # library that has the requirements and the value of the Hash is an Array
    # of the requirements that could be not be found in the library list.
    #
    # @return [Hash] Unresolved requirements
    #
    def unresolved
      list = Hash.new{ |h,k| h[k] = [] }
      @failures.each do |name, number|
        requirements(name, number).each do |rname, rnumber|
          list[[name,number]] << [rname, rnumber] if possibilities(rname, rnumber.to_s).empty?
        end
      end
      list
    end

  private

    #
    #
    #
    def resolve_(name, number, sheet={})
      # prevent infinite recursion
      return sheet if @cache[[name,number]]
      @cache[[name,number]] = true

      return false unless settle(name, number, sheet)

      requirements = requirements(name, number)

      # there are no requirements to resolve
      return sheet if requirements.empty?

      # what possibilites exist for resolving all the requirements
      potents = requirements.map do |(n, c)|
                  possibilities(n,c)
                end

      # TODO: I think this might be a mistake, if there are no possibilities then is it not
      #       a failed resolution? Consider adding to failures and returning false instead.
      return sheet if potents.empty?

      vectors = product(*potents)

      success = vectors.find do |vector|
                  resolve_vector(vector, sheet)
                end

      unless success
        @failures << [name, number] unless @failures.include?([name, number])
      end

      return success
    end

    #
    #
    #
    def cached(name, number, sheet)
      @cache[[name, number]] = true
      sheet
    end

    #
    #
    #
    def resolve_vector(vector, sheet)
      vector.each do |(n,v)|
        r = resolve_(n, v, sheet)
        return false unless r
      end
      return sheet
    end

    #
    #
    #
    def settle(name, number, sheet={})
      if sheet[name]
        return false if sheet[name] != number
      else
        sheet[name] = number
      end
      return true
    end

    #
    #
    #
    def product(*list)
      return [] if list.empty?
      head, *rest = *list
      head.product(*rest)
    end

=begin
    #
    #
    #
    def collect_possibilites
      possibilites = Hash.new{ |h,k| h[k] = Hash.new{|h2,k2| h2[k2] = [] } }
      constrained_versions = collect_constraints
      libraries.each do |name, version, requirements|
        requirements.each do |(n,c)|
          possibilites[[name, version]][n] << constrained_versions[[n,c]]
        end
      end
      possibilites
    end

    #
    # Iterate over all requirements and collect all possible versions
    # that fit their constraints.
    #
    def collect_constraints
      constraints = {}
      @libraries.each do |name, version, requirements|
        requirements.each do |n,c|
          next if constraints[[n,c]]
          constraints[[n,c]] = matching_versions(n,c)
        end
      end
      constraints
    end

    #
    #
    #
    def matching_versions(name, constraint)
      vers = @versions[name].select{ |v| constraint.fits?(v) }.sort
      vers.map{ |v| [name, v] }
    end
=end



=begin
    # Resolve dependencies for given list of name-version.
    #
    # @param [Array] list
    #
    def resolve(list)
      requirements = collect_requirements(list)

      # time to do some backtracking
      first, *rest = *requirements.values
      first.product(*rest).find |possibility|
        valid?(possibility)
      end
    end

    #
    # Collect requirements for given set of desired entries.
    #
    # TODO: Reduce requirements for same names
    #
    def collect_requirements(list)
      requirements = {}
      list.each do |(name, version)|
        if @requirements.key?([name,version])
          @requirements[[name,version]].each do |(n,c)|
            next if requirements[[n,c]]
            requirements[[n,c]] = matching_versions(n,c)
          end
        else
          raise "no resolution - no available entry for #{name}-#{verison}"
        end
      end
      requirements
    end

    #
    #
    #
    def resolve_
      reqs = {}
      constraints.each do |name, *cons|
        reqs[name] = reduce(*cons)
      end
      reqs
    end

    #
    #
    #
    def constraints(list)
      cons = {}
      list.each do |(name, constraint)|
        cons[name.to_s] ||= []
        cons[name.to_s] << Constraint.parse(constraint)
      end
      cons
    end
=end

    #
    #
    #
    def reduce(*constraints)
      exact, least, most = nil , nil, nil

      constraints.each do |c|
        case c.op
        when '==', '='
          if exact
            if exact != c.number
              exact, least, most = nil, nil, nil
              break
            end
          else
            exact = c
          end
        when '<'
          if least
            if c.number <= least.number
              least = c
            end
          else
            least = c
          end
        when '>'
          if most
            if c.number >= most.number
              most = c
            end
          else
            most = c
          end
        when '<='
          if least
            if c.number < least.number
              least = c
            end
          else
            least = c
          end
        when '>='
          if most
            if c.number > most.number
              most = c
            end
          else
            most = c
          end
        when '=~'
          # TODO
        end
      end

      # there be only one!
      return nil if exact && least
      return nil if exact && most
      return nil if least && most

      exact || least || most
    end

  end

end

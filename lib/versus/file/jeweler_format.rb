module Version

  class File

    # Jeweler style VERSION file, e.g.
    #
    #   ---
    #   :major: 1
    #   :minor: 0
    #   :patch: 0
    #   :build: pre.1
    #
    module JewelerFormat
      extend self

      #
      #
      #
      def match?(path, data)
        return false unless Hash === data
        data = data.inject({}){|h,(k,v)| h[k.to_sym]=v; h}
        keys = data.keys - [:major, :minor, :patch, :build]
        keys.empty?
      end

      #
      #
      #
      def render(number)
        ":major: #{number[0]}\n" +
        ":minor: #{number[1]}\n" +
        ":patch: #{number[2]}\n" +
        ":build: #{number[3..-1].join('.')}\n"
      end

      #
      #
      #
      def parse(data)
        data = data.inject({}){|h,(k,v)| h[k.to_sym]=v; h}
        tuple = data.values_at(:major,:minor,:patch,:build).compact
        Number.new(*tuple)
      end

    end

  end

end

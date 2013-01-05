module Version

  class File

    # Plain style version file, e.g.
    #
    #   1.2.0
    #
    module PlainFormat
      extend self

      #
      #
      #
      def match?(data)
        return false unless String === data
        # TODO: re-match here
        return true
      end

      #
      #
      #
      def render(number)
        number.to_s
      end

      #
      #
      #
      def parse(string)
        Number.parse(string.strip)
      end

    end

  end

end

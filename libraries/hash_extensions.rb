module Ingenerator
  module Helpers

    ##
    # This mixin provides additional functionality to any hash object, including
    # node attributes.
    module Hash

      ##
      # Returns an array with all the keys corresponding to boolean `true` values,
      # in alphabetical order.
      #
      # @raise  ArgumentError if any hash key has a non-boolean value
      # @return [Array<String>]
      def list_active_keys
        self.select do | key, value |
          is_bool = ((value === true) || (value === false))
          unless is_bool
            raise ArgumentError.new(
              "list_active_keys requires boolean values - got '#{value}' for '#{key}'"
            )
          end
          value
        end.keys.sort
      end
    end
  end
end

Hash.include(Ingenerator::Helpers::Hash)

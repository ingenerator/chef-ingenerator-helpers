module Ingenerator
  module Helpers
    module Attributes

      ##
      # Thrown when an attribute has not been customised properly
      #
      class DefaultAttributeValueError < SecurityError
        def initialize(attr_path, default_value)
          super "For security, you must override value of #{attr_path} to something other than the default of '#{default_value}'"
        end
      end

      ##
      # Raises an exception if an attribute value has not been overriden
      #
      #   # attributes/default.rb
      #   default['service']['password'] = 'letmein'
      #
      #   # recipes/default.rb
      #   if not_environment?(:localdev) raise_unless_customised('service', 'password')
      #
      # This will throw unless you set an override value eg in a node, role or environment
      #
      def raise_unless_customised( * attribute_keys)
        values = node.debug_value( * attribute_keys).to_h
        values.delete('set_unless_enabled?')
        assigned_values = values.select { | k,v | v != :not_present }

        if assigned_values.empty?
          raise ArgumentError.new('Undefined attribute : '+format_attr_path(attribute_keys))
        end

        default_value = assigned_values.select { | k, v | k.include? 'default' }.values.last
        current_value = assigned_values.values.last

        if default_value.is_a?(Enumerable)
          raise ArgumentError.new('Expected simple scalar value for '+format_attr_path(attribute_keys))
        end

        if current_value == default_value
          raise DefaultAttributeValueError.new(format_attr_path(attribute_keys), default_value)
        end
      end

      private

      def format_attr_path( * keys)
        "node[#{keys.join('][')}]"
      end

    end
  end
end

Chef::Recipe.send(:include, Ingenerator::Helpers::Attributes)

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
      # Thrown when a project / wrapper cookbook / defines attributes that are no longer supported by
      # underlying cookbooks.
      class LegacyAttributeDefinitionError < ArgumentError
        def initialize(invalid_attributes)
          msg = "Legacy node attribute definitions found\n"
          msg += "You are defining node attributes that no longer take effect - roles, recipes and attributes need to be updated:\n"

          invalid_attributes.each do | attribute_path, value_assignments |
            value = value_assignments.values.last
            msg += "#{attribute_path} => #{value} ("+value_assignments.keys.join(', ')+")\n"
          end

          super msg
        end
      end

      ##
      # Raises an exception if any of the specified attribute values exist, to help
      # detecting older versions of projects that use attributes that no longer work
      #
      #   raise_if_legacy_attributes('mysql.stuff', 'mysql.otherstuff')
      #
      # @param [Array<String>] dot-separated paths to reject
      #
      def raise_if_legacy_attributes( * attribute_paths)
        invalid = {}
        attribute_paths.each do | attribute_path |
          values = find_assigned_attribute_values(attribute_path)
          if values.any?
            invalid[format_attr_path(attribute_path)] = values
          end
        end

        if invalid.any?
          raise LegacyAttributeDefinitionError.new(invalid)
        end
      end

      ##
      # Raises an exception if an attribute value has not been overriden
      #
      #   # attributes/default.rb
      #   default['service']['password'] = 'letmein'
      #
      #   # recipes/default.rb
      #   if not_environment?(:localdev) raise_unless_customised('service.password')
      #
      # This will throw unless you set an override value eg in a node, role or environment
      # @param String dot-separated path to the node attribute
      #
      def raise_unless_customised(attribute_path)
        assigned_values = find_assigned_attribute_values(attribute_path)

        if assigned_values.empty?
          raise ArgumentError.new('Undefined attribute : '+format_attr_path(attribute_path))
        end

        default_value = assigned_values.select { | k, v | k.include? 'default' }.values.last
        current_value = assigned_values.values.last

        if default_value.is_a?(Enumerable)
          raise ArgumentError.new('Expected simple scalar value for '+format_attr_path(attribute_path))
        end

        if current_value == default_value
          raise DefaultAttributeValueError.new(format_attr_path(attribute_path), default_value)
        end
      end

      private

      def find_assigned_attribute_values(attribute_path)
        keys  = attribute_path.split('.')
        debug = node.debug_value( * keys).to_h
        debug.delete('set_unless_enabled?')
        debug.select { | k,v | v != :not_present }
      end

      def format_attr_path(attribute_path)
        bracket_path = attribute_path.sub('.', '][')
        "node[#{bracket_path}]"
      end

    end
  end
end

Chef::Recipe.send(:include, Ingenerator::Helpers::Attributes)

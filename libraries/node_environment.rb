module Ingenerator
  module Helpers
    module Node_Environment

      # Test if this is one of the specified environment(s)
      #
      #   is_environment?(:localdev)
      #   is_environment?(:localdev, :buildslave) # equivalent to an OR
      #
      def is_environment?( * environments)
        matched = environments.select { | env | node_environment === env.to_sym }
        matched.any?
      end

      # Test if this is not one of the specified environments
      #
      #   not_environment?(:localdev)
      #   not_environment?(:localdev, :buildslave) # equivalent to AND NOT
      #
      def not_environment?( * environments)
        ! is_environment?( * environments)
      end

      # Get the current node environment
      def node_environment
        if node['ingenerator'] && node['ingenerator']['node_environment']
          node['ingenerator']['node_environment'].to_sym
        else
          :production
        end
      end

      # Get the project name - if not assigned, will throw an exception
      #
      # @return string
      # @raise ArgumentArror if the name is not defined
      def ingenerator_project_name
        unless node['project'] && node['project']['name']
          raise ArgumentError.new('You must configure a node[project][name] attribute')
        end
        node['project']['name']
      end

    end
  end
end

# Make the helpers available in all recipes
Chef::Recipe.send(:include, Ingenerator::Helpers::Node_Environment)
Chef::Node.send(:include, Ingenerator::Helpers::Node_Environment)

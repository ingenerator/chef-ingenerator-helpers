module Ingenerator
  module Helpers
    module Node_Environment

      # Test if this is the specified environment
      def is_environment?(env)
        node_environment === env.to_sym
      end

      # Test if this is not the specified environment
      def not_environment?(env)
        node_environment != env.to_sym
      end

      # Get the current node environment
      def node_environment
        if node['ingenerator'] && node['ingenerator']['node_environment']
          node['ingenerator']['node_environment'].to_sym
        else
          :production
        end
      end
    end
  end
end

# Make the helpers available in all recipes
Chef::Recipe.send(:include, Ingenerator::Helpers::Node_Environment)
Chef::Node.send(:include, Ingenerator::Helpers::Node_Environment)

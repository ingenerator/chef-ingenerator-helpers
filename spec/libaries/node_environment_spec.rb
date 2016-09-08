require 'spec_helper'
require_relative '../../libraries/node_environment.rb'

describe Ingenerator::Helpers::Node_Environment do
  let (:my_recipe) { Class.new { extend Ingenerator::Helpers::Node_Environment }}
  let (:node)      { Chef::Node.new }

  before :example do
    allow(my_recipe).to receive(:node).and_return(node)
  end

  shared_examples 'it handles the node_environment as expected' do | is_environment, not_environment |

    describe 'node_environment' do
      it "is :#{is_environment}" do
        expect(my_recipe.node_environment).to be(is_environment)
      end
    end

    describe 'is_environment?' do
      it "matches :#{is_environment}" do
        expect(my_recipe.is_environment?(is_environment)).to be(true)
      end

      it "matches '#{is_environment}'" do
        expect(my_recipe.is_environment?("#{is_environment}")).to be(true)
      end

      it "does not match :#{not_environment}" do
        expect(my_recipe.is_environment?(not_environment)).to be(false)
      end

      it "does not match '#{not_environment}'" do
        expect(my_recipe.is_environment?("#{not_environment}")).to be(false)
      end

      it "matches list of :#{not_environment}, :#{is_environment}" do
        expect(my_recipe.is_environment?(not_environment, is_environment)).to be(true)
      end

      it "does not match list of :#{not_environment}, :unknown-environment" do
        expect(my_recipe.is_environment?(not_environment, :'unknown-environment')).to be(false)
      end
    end

    describe 'not_environment?' do
      it "matches :#{not_environment}" do
        expect(my_recipe.not_environment?(not_environment)).to be(true)
      end

      it "matches '#{not_environment}'" do
        expect(my_recipe.not_environment?("#{not_environment}")).to be(true)
      end

      it "does not match :#{is_environment}" do
        expect(my_recipe.not_environment?(is_environment)).to be(false)
      end

      it "does not match '#{is_environment}'" do
        expect(my_recipe.not_environment?("#{is_environment}")).to be(false)
      end

      it "does not match list of :#{not_environment}, :#{is_environment}}" do
        expect(my_recipe.not_environment?(not_environment, is_environment)).to be(false)
      end

      it "matches list of :#{not_environment}, :unknown-environment" do
        expect(my_recipe.not_environment?(not_environment, :'unknown-environment')).to be(true)
      end

    end
  end

  context 'when no node_environment is configured' do
    include_examples 'it handles the node_environment as expected', :production, :localdev
  end

  context "when node_environment is configured as (string) 'buildslave'" do
    before :example do
      node.normal['ingenerator']['node_environment'] = 'buildslave'
    end

    include_examples 'it handles the node_environment as expected', :buildslave, :production
  end

  context 'when node_environment is configured as (symbol) :localdev' do
    before :example do
      node.normal['ingenerator']['node_environment'] = :localdev
    end

    include_examples 'it handles the node_environment as expected', :localdev, :production
  end

  describe 'ingenerator_project_name' do
    context 'when no name is defined (by default)' do
      it 'raises an exception' do
        expect {
          my_recipe.ingenerator_project_name
        }.to raise_exception ArgumentError
      end
    end

    context 'when a name is defined' do
      before :example do
        node.normal['project']['name'] = 'ourproject'
      end

      it 'returns the name' do
        expect(my_recipe.ingenerator_project_name).to eq('ourproject')
      end
    end
  end
end

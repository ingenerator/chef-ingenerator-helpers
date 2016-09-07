require 'spec_helper'
require_relative '../../libraries/node_environment.rb'

describe Ingenerator::Helpers::Node_Environment do
  let (:my_recipe) { Class.new { extend Ingenerator::Helpers::Node_Environment }}

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

    end
  end

  context 'when no node_environment is configured' do
    before(:each) do
      allow(my_recipe).to receive(:node).and_return({})
    end

    include_examples 'it handles the node_environment as expected', :production, :localdev
  end

  context "when node_environment is configured as (string) 'buildslave'" do
    before(:each) do
      allow(my_recipe).to receive(:node).and_return({
        'ingenerator' => {'node_environment' => 'buildslave'}
      })
    end

    include_examples 'it handles the node_environment as expected', :buildslave, :production
  end

  context 'when node_environment is configured as (symbol) :localdev' do
    before(:each) do
      allow(my_recipe).to receive(:node).and_return({
        'ingenerator' => {'node_environment' => :localdev}
      })
    end

    include_examples 'it handles the node_environment as expected', :localdev, :production
  end

end

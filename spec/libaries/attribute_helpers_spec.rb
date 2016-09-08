require 'spec_helper'
require_relative '../../libraries/attribute_helpers.rb'

describe Ingenerator::Helpers::Attributes do
  let (:my_recipe) { Class.new { extend Ingenerator::Helpers::Attributes } }
  let (:node)      { Chef::Node.new }

  before :example do
    allow(my_recipe).to receive(:node).and_return(node)
  end

  describe 'raise_if_legacy_attributes' do
    context 'with one search attribute' do
      it 'passes if the attribute is not defined' do
        expect(my_recipe.raise_if_legacy_attributes('nothing.too.see')).to eq(nil)
      end

      it 'raises an exception if the attribute is defined' do
        node.default['nothing']['too']['see'] = 'i-should-be-gone'
        expect {
          my_recipe.raise_if_legacy_attributes('nothing.too.see')
        }.to raise_exception(Ingenerator::Helpers::Attributes::LegacyAttributeDefinitionError)
      end
    end

    context 'with multiple search attributes' do
      it 'passes if none of the attributes are defined' do
        node.default['valid'] = 'ok'
        expect(my_recipe.raise_if_legacy_attributes('bad.stuff', 'other.things')).to eq(nil)
      end

      it 'raises an exception if one of the attributes is defined' do
        node.default['valid'] = 'ok'
        node.default['other']['things'] = 'wrong'
        expect {
          my_recipe.raise_if_legacy_attributes('bad.stuff', 'other.things')
        }.to raise_exception(Ingenerator::Helpers::Attributes::LegacyAttributeDefinitionError)
      end

      it 'raises an exception if all of the attributes are defined' do
        node.default['valid'] = 'ok'
        node.default['bad']['stuff'] = 'stillwrong'
        node.normal['other']['things'] = 'wrong'
        expect {
          my_recipe.raise_if_legacy_attributes('bad.stuff', 'other.things')
        }.to raise_exception(Ingenerator::Helpers::Attributes::LegacyAttributeDefinitionError)
      end
    end
  end

  describe 'raise_unless_customised' do
     it 'does something when there is no value' do
       expect {
         my_recipe.raise_unless_customised('some.attribute')
       }.to raise_exception(ArgumentError)
     end

     it 'raises an exception when the attribute only has a default value' do
       node.default['any']['attribute'] = 'default'
       expect {
         my_recipe.raise_unless_customised('any.attribute')
       }.to raise_exception(Ingenerator::Helpers::Attributes::DefaultAttributeValueError)
     end

     it 'raises an exception when the override value is the same as the default' do
       node.default['any']['attribute'] = 'default'
       node.normal['any']['attribute']  = 'default'
       expect {
         my_recipe.raise_unless_customised('any.attribute')
       }.to raise_exception(Ingenerator::Helpers::Attributes::DefaultAttributeValueError)
     end

     it 'raises an exception when the default value is a hash' do
       node.default['some']['deep']['attribute']['stuff'] = 'anything'
       expect {
         my_recipe.raise_unless_customised('some.deep')
       }.to raise_exception(ArgumentError)
     end

     it 'raises an exception when the default value is an array' do
       node.default['some']['array']['attribute'] = ['anything', 'else']
       expect {
         my_recipe.raise_unless_customised('some.array.attribute')
       }.to raise_exception(ArgumentError)
     end

     it 'passes when the value has been overridden at single level' do
       node.default['any']['attribute'] = 'default'
       node.normal['any']['attribute']  = 'custom'
       expect(my_recipe.raise_unless_customised('any.attribute')).to eq(nil)
     end

     it 'passes when the value has been overridden at multiple levels' do
       node.default['any']['attribute']  = 'default'
       node.normal['any']['attribute']   = 'default'
       node.override['any']['attribute'] = 'finalvalue'
       expect(my_recipe.raise_unless_customised('any.attribute')).to eq(nil)
     end
  end
end

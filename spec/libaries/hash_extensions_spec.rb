require 'spec_helper'
require_relative '../../libraries/hash_extensions.rb'

describe Ingenerator::Helpers::Hash do

  describe 'list_active_keys' do
    context 'with empty hash' do
      let (:subject) { {} }

      it 'returns empty array' do
        expect(subject.list_active_keys).to eq([])
      end
    end

    context 'with hash containing only true values' do
      let (:subject) { {
        'first'  => true,
        'second' => true,
        'last'   => true
      }}

      it 'returns ordered array of keys' do
        expect(subject.list_active_keys).to eq(['first', 'last', 'second'])
      end
    end

    context 'with hash containing true and false values' do
      let (:subject) { {
        'second' => true,
        'first'  => false,
        'last'   => true
      }}

      it 'returns ordered array only of keys with value == true' do
        expect(subject.list_active_keys).to eq(['last', 'second'])
      end
    end

    context 'with hash containing non-boolean values' do
      let (:subject) { {
        'first' => true,
        'other' => 'stuff'
      }}

      it 'throws an exception' do
        expect { subject.list_active_keys }.to raise_exception(ArgumentError)
      end
    end
  end
end

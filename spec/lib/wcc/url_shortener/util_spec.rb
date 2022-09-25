# frozen_string_literal: true

require 'spec_helper'

require 'wcc/url_shortener'
require 'wcc/url_shortener/application'

RSpec.describe WCC::UrlShortener::Util do
  describe '.path_to_regexp' do
    describe 'splat *' do
      it 'converts to match anything' do
        result = WCC::UrlShortener::Util.path_to_regexp('/a/*')

        expect(result.match('/a/123/456')).to_not be_nil
        expect(result.match('/b/123/456')).to be_nil

        expect(result.match('/a/123/456.jpg')['splat']).to eq('/123/456.jpg')

        expect(result.to_s).to eq('(?-mix:\\/a(?<splat>[^\\?]*))')
      end

      it 'stops at query string' do
        result = WCC::UrlShortener::Util.path_to_regexp('/a/*')

        expect(result.match('/a/123/456.jpg?utm_source=test')).to_not be_nil
        expect(result.match('/a/123/456.jpg?utm_source=test')['splat']).to eq('/123/456.jpg')
      end
    end

    describe 'optional ?' do
      it 'matches both options' do
        result = WCC::UrlShortener::Util.path_to_regexp('https?:')

        expect(result.to_s).to eq(/https?:/.to_s)

        expect(result.match('http:')).to_not be_nil
        expect(result.match('https:')).to_not be_nil
        expect(result.match('httpq:')).to be_nil
      end
    end

    describe 'named path param :test' do
      it 'sets match group' do
        result = WCC::UrlShortener::Util.path_to_regexp('/blog/:slug/:digest')

        expect(result.to_s).to eq('(?-mix:\\/blog\\/(?<slug>[^\\/\\?]+)\\/(?<digest>[^\\/\\?]+))')

        match = result.match('/blog/something-something-123/abcd1234.xyz')
        expect(match).to_not be_nil

        expect(match['slug']).to eq('something-something-123')
        expect(match['digest']).to eq('abcd1234.xyz')
      end
    end
  end
end

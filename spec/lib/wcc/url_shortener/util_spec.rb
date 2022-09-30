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

        expect(result.match('http:')).to_not be_nil
        expect(result.match('https:')).to_not be_nil
        expect(result.match('httpq:')).to be_nil
      end
    end

    describe 'named path param :test' do
      it 'sets match group' do
        result = WCC::UrlShortener::Util.path_to_regexp('/blog/:slug/:digest')

        match = result.match('/blog/something-something-123/abcd1234.xyz')
        expect(match).to_not be_nil

        expect(match['slug']).to eq('something-something-123')
        expect(match['digest']).to eq('abcd1234.xyz')
      end
    end

    describe 'no splat' do
      it 'does not match subpaths' do
        result = WCC::UrlShortener::Util.path_to_regexp('/a')

        expect(result.match('/a')).to_not be_nil
        expect(result.match('/a/123')).to be_nil
      end

      it 'does match exact path with query params' do
        result = WCC::UrlShortener::Util.path_to_regexp('/a')

        expect(result.match('/a?test=1&utm_source=something')).to_not be_nil
      end
    end
  end
end

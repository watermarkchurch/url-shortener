# frozen_string_literal: true

require 'spec_helper'

require 'wcc/url_shortener'
require 'wcc/url_shortener/application'

RSpec.describe('config/redirects') do
  include Rack::Test::Methods

  let(:app) { WCC::UrlShortener::Application.new.to_app }

  {
    'https://www.wmfw.org/test' => ['https://www.watermarkfortworth.org/test', 302],
    'http://www.watermarkfw.org/abc/123.jpg' => ['https://www.watermarkfortworth.org/abc/123.jpg', 302],

    'https://redirect.churchleadersconference.com/blargh?test=1' => ['https://www.watermarkresources.com/conferences/clc?test=1&utm_source=churchleadersconference.com', 302],

    'https://marriagehelp.org/test/abc/123.jpg' => 'https://www.reengage.org/legacy/test/abc/123.jpg',
    'https://www.marriagehelp.org' => 'https://www.reengage.org/legacy',
    
    'https://legacy.watermark.org/123.jpg?a=1' => 'https://www.watermark.org/123.jpg?a=1',
    'https://staging-new.watermark.org' => 'https://staging.watermark.org',

    'https://papyrus.watermark.org/api/v1/property/paper_signs' => 'https://www.watermark.org/api/v1/property/paper_signs',

    'https://live.theporchdallas.com/blog' => 'https://www.theporch.live/live-stream',
    'https://old.theporch.live/blog' => 'https://www.theporch.live/blog',
    'https://theporchdallas.com/blog' => 'https://www.theporch.live/legacy/blog',

    'https://clc2023.com/blog?test=1' => 'https://www.watermarkresources.com/conferences/clc/blog?test=1&utm_source=clc2023.com',
    'https://thechurchleadershipconference.com' => 'https://www.watermarkresources.com/conferences/clc?utm_source=thechurchleadershipconference.com',
  }.each do |from, to|
    url, status = Array(to)

    it "redirects #{from} to #{url}#{(" with status #{status}" if status)}" do
      get from

      expect(last_response.status).to eq(status || 301)
      expect(last_response.headers['Location']).to eq(url)
    end
  end
end

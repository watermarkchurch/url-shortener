# frozen_string_literal: true

require 'spec_helper'

require 'wcc/url_shortener'
require 'wcc/url_shortener/application'

RSpec.describe do
  include Rack::Test::Methods

  let(:app) { WCC::UrlShortener::Application.new.to_app }

  it 'gets root' do
    get '/'

    expect(last_response.status).to eq(200)
  end
end

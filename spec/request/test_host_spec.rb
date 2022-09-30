
require 'spec_helper'

require 'wcc/url_shortener'

RSpec.describe('config/initializers/redirect_router') do
  include Rack::Test::Methods

  let(:app) { WCC::UrlShortener.application.to_app }

  it 'overrides hostname based on X-Test-Host header', focus: true do
    
    header 'X-Test-Host', 'theporchdallas.com'

    get '/blog'

    # should match theporchdallas.com -> theporch.live redirect
    expect(last_response.status).to eq(301)
    expect(last_response.headers['Location']).to eq('https://www.theporch.live/legacy/blog')
  end
end
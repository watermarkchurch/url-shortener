# frozen_string_literal: true

require 'bugsnag'

Bugsnag.configure do |config|
  config.api_key = ENV.fetch('BUGSNAG_API_KEY', nil)
end

WCC::UrlShortener.application.middleware.use Bugsnag::Rack

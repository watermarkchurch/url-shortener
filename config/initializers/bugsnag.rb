# frozen_string_literal: true

require 'bugsnag'

Bugsnag.configure do |config|
  config.api_key = ENV.fetch('BUGSNAG_API_KEY', nil)
  config.project_root = WCC::UrlShortener.application.root.to_s
end

WCC::UrlShortener.application.middleware.insert_before 0,
  Bugsnag::Rack

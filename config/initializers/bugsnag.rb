# frozen_string_literal: true

require 'English'
require 'bugsnag'

Bugsnag.configure do |config|
  config.api_key = ENV.fetch('BUGSNAG_API_KEY', nil)
  config.project_root = WCC::UrlShortener.application.root.to_s
end

WCC::UrlShortener.application.middleware.insert_before 0,
  Bugsnag::Rack

at_exit do
  Bugsnag.notify($ERROR_INFO) if $ERROR_INFO
end

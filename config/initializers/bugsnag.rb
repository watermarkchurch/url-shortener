require 'bugsnag'

Bugsnag.configure do |config|
  config.api_key = ENV['BUGSNAG_API_KEY']
end

WCC::UrlShortener.application.middleware.use Bugsnag::Rack

# frozen_string_literal: true

require 'wcc/url_shortener/middleware/test_host'

WCC::UrlShortener.application.middleware.insert_before WCC::UrlShortener::Middleware::RedirectRouter,
  WCC::UrlShortener::Middleware::TestHost

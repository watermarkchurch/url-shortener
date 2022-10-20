# frozen_string_literal: true

require 'wcc/url_shortener/middleware/redirect_router'

redirects = File.readlines(WCC::UrlShortener.application.root.join('config/redirects'))

WCC::UrlShortener.application.middleware.insert_before Rack::Static,
  WCC::UrlShortener::Middleware::RedirectRouter, redirects

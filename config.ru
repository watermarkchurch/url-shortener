# frozen_string_literal: true

require_relative './lib/wcc/url_shortener'

run WCC::UrlShortener.application.to_app

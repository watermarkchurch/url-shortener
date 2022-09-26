# frozen_string_literal: true

$LOAD_PATH.unshift(File.expand_path(File.join(__dir__, 'lib'))) unless $LOAD_PATH.include?(File.expand_path(File.join(__dir__, 'lib')))

require 'wcc/url_shortener'

run WCC::UrlShortener.application.to_app

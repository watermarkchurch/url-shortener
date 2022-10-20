# frozen_string_literal: true

require_relative './url_shortener/version'

module WCC::UrlShortener
  def self.application
    @application ||=
      begin
        require_relative './url_shortener/application'

        Application.new
      end
  end
end

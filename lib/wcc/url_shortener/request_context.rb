# frozen_string_literal: true

class WCC::UrlShortener::RequestContext
  attr_reader :request

  def initialize(request)
    @request = request
  end
end

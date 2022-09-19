# frozen_string_literal: true

require_relative './request_context'

class WCC::UrlShortener::Application
  def call(env)
    request = Rack::Request.new(env)
    context = WCC::UrlShortener::RequestContext.new(request)

    run_request(request, context)
  end

  private

  def run_request(request, _context)
    [200, {}, ["Hello World: #{request.path}"]]
  end
end

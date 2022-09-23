
require_relative './util'

class WCC::UrlShortener::RedirectRouter
  def initialize(app, redirects)
    @app = app
    @redirects = parse_redirects(redirects).compact
  end

  def call(env)
    request = Rack::Request.new(env)
    if route = lookup(request)
      return route.call(request)
    end

    return @app.call(env)
  end

  private

  def lookup(request)
    @redirects.detect { |r| r.match?(request) }
  end

  def parse_redirects(redirects)
    redirects.map do |r|
      from, to, status, preserve = r.split(/\s+/)
      next unless /\S/ =~ from

      Route.new(
        WCC::UrlShortener::Util.path_to_regexp(from),
        to,
        status || 301,
        preserve&.downcase == 'preserve'
      )
    end
  end

  Route = Struct.new(:from, :to, :status, :preserve) do
    def match?(request)
      from =~ request.url
    end

    def call(request)
      match = from.match(request.url)

      # Replace any :splat or :var in to line
      location = match.named_captures.reduce(to) do |str, (name, value)|
        str.gsub(":#{name}", value)
      end
      location = URI(location)

      # merge in queries from "to"
      request_query = Rack::Utils.parse_query(request.query_string)
      to_query = Rack::Utils.parse_query(location.query) if location.query
      final_query =
        if to_query
          request_query.merge(to_query)
        elsif request_query.count > 0
          request_query
        end
      location.query = Rack::Utils.build_query(final_query) if final_query && final_query.count > 0 

      if preserve
        # Append incoming path to the TO path
        if request.path && request.path != '/'
          location.path = location.path.sub(/\/$/, '') + request.path
        end
      end

      [status, { 'Location' => location.to_s }, []]
    end
  end
end
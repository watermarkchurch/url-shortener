# frozen_string_literal: true

class WCC::UrlShortener::Middleware::RedirectRouter
  def initialize(app, redirects)
    @app = app
    @redirects = parse_redirects(redirects).compact
  end

  def call(env)
    request = Rack::Request.new(env.dup)
    # An incoming request for `https://#{host}` is equivalent to `https://#{host}/`.
    # Stripping that out helps when the splat is appended to a subpath like /legacy/:splat
    request.path_info = '' if request.path_info == '/'

    if route = lookup(request)
      return route.call(request)
    end

    @app.call(env)
  end

  private

  def lookup(request)
    @redirects.find { |r| r.match?(request) }
  end

  def parse_redirects(redirects)
    redirects.map do |r|
      from, to, status = r.split(/\s+/)
      next unless /\S/ =~ from && /^\s*\#/ !~ from

      Route.new(
        WCC::UrlShortener::Util.path_to_regexp(from),
        to,
        status || 301
      )
    end
  end

  Route =
    Struct.new(:from, :to, :status) do
      def match?(request)
        from =~ request.url
      end

      def call(request) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
        match = from.match(request.url)

        # Replace any :splat or :var in the to line
        location =
          match.named_captures.reduce(to) do |str, (name, value)|
            str.gsub(/\/?:#{name}/, value)
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

        [status, { 'Location' => location.to_s }, []]
      end
    end
end

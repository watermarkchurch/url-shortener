# frozen_string_literal: true

class WCC::UrlShortener::Middleware::TestHost

  def initialize(app)
    @app = app
  end

  def call(env)
    if env['HTTP_X_TEST_HOST'] && /\S/ =~ env['HTTP_X_TEST_HOST']
      # pretend like there's a proxy in front that's listening at our HTTP_X_TEST_HOST hostname
      env['HTTP_X_FORWARDED_HOST'] = env['HTTP_X_TEST_HOST']
    end

    @app.call(env)
  end
end
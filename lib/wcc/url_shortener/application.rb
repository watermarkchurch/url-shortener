# frozen_string_literal: true

require 'rack/builder'
require 'rack/static'

class WCC::UrlShortener::Application

  def root
    # Project root - allows accessing config dir
    Pathname.new(File.expand_path(File.join(__dir__, '../../..')))
  end

  def middleware
    @app
  end

  def initialize
    @app = Rack::Builder.new do
      # Defaults
      use Rack::Static, :urls => [""], :root => 'public', :index => 'index.html'

      run ->(env) { [404, {}, ["Not Found: #{Rack::Request.new(env).path}"]] }
    end
  end

  def prepare!
    raise StandardError, 'Cannot prepare twice!' if prepared?

    Dir[root.join('config/initializers/*.rb')].sort.each { |f| require f }

    @prepared = true
  end

  def prepared?
    @prepared == true
  end

  def to_app
    prepare! unless prepared?

    @app
  end
end

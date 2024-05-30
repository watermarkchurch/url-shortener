# frozen_string_literal: true

require 'delegate'
require 'rack/builder'
require 'rack/static'
require 'rack/common_logger'
require 'rack/conditional_get'
require 'rack/etag'
require 'rack/deflater'

require_relative 'util'
require_relative 'middleware'

class WCC::UrlShortener::Application
  def root
    # Project root - allows accessing config dir
    Pathname.new(File.expand_path(File.join(__dir__, '../../..')))
  end

  def middleware
    @middleware ||= MiddlewareStack.new(
      [
        Rack::Deflater,
        Rack::Head,
        Rack::ConditionalGet,
        Rack::ETag,
        [Rack::Static, { cascade: true, urls: [''], root: 'public', index: 'index.html' }]
      ]
    )
  end

  def prepare!
    raise StandardError, 'Cannot prepare twice!' if prepared?

    # Load all middleware
    Dir[root.join('config/initializers/*.rb')].each { |f| require f }

    @app = Rack::Builder.new
    middleware.each do |m|
      @app.use(*Array(m))
    end

    @app.run self

    @app
  end

  def prepared?
    @app != nil
  end

  def to_app
    prepare! unless prepared?

    @app.to_app
  end

  def call(env)
    [404, {}, ["Not Found: #{Rack::Request.new(env).path}"]]
  end

  class MiddlewareStack < SimpleDelegator
    def use(*args)
      push(args)
    end

    def insert_before(target, *args)
      idx = find_target_index(target)

      insert(idx, args)
    end

    def insert_after(target, *args)
      idx = find_target_index(target)

      insert(idx + 1, args)
    end

    private

    def find_target_index(target)
      return target if target.is_a?(Integer)

      idx =
        find_index do |m|
          klass, = Array(m)
          target == klass
        end
      raise ArgumentError, "Could not find #{target} in middleware stack" unless idx && idx >= 0

      idx
    end
  end
end

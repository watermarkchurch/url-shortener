# frozen_string_literal: true

require 'delegate'
require 'rack/builder'
require 'rack/static'
require 'rack/common_logger'
require 'rack/conditional_get'
require 'rack/etag'
require 'rack/deflater'

require_relative './redirect_router'

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
        [WCC::UrlShortener::RedirectRouter, redirects],
        [Rack::Static, { cascade: true, urls: [''], root: 'public', index: 'index.html' }],
      ],
    )
  end

  attr_reader :redirects

  def initialize
    load_redirects!
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

  private

  def load_redirects!
    @redirects ||= File.readlines(root.join('config/redirects')) # rubocop:disable Naming/MemoizedInstanceVariableName
  end

  class MiddlewareStack < SimpleDelegator
    def use(*args)
      push(args)
    end

    def insert_before(middleware_class, *args)
      idx =
        find_index do |m|
          klass, = Array(m)
          middleware_class == klass
        end
      raise ArgumentError, "Could not find #{middleware_class} in middleware stack" unless idx && idx >= 0

      insert(idx, args)
    end

    def insert_after(middleware_class, *args)
      idx =
        find_index do |m|
          klass, = Array(m)
          middleware_class == klass
        end
      raise ArgumentError, "Could not find #{middleware_class} in middleware stack" unless idx && idx >= 0

      insert(idx + 1, args)
    end
  end
end

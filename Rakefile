# frozen_string_literal: true

desc 'prints the classes in the final Rack application'
task :middleware do
  require_relative './lib/wcc/url_shortener'

  app = WCC::UrlShortener.application.to_app
  klasses = [app.class]
  while app = app.instance_variable_get(:@app)
    klasses << app.class
  end
  puts klasses
end

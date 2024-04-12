# frozen_string_literal: true

$LOAD_PATH.unshift(File.expand_path(File.join(__dir__, 'lib'))) unless $LOAD_PATH.include?(File.expand_path(File.join(
  __dir__, 'lib'
)))

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

desc 'Verifies that the new redirector sends the same Location header as the old one'
task :verify, [:url, :file] do |_t, args|
  require 'uri'
  require 'typhoeus'

  url = URI(args[:url]) if args[:url]
  file = args[:file] || './spec/fixtures/redirects.txt'

  hydra = Typhoeus::Hydra.new(max_concurrency: 2)

  FileUtils.mkdir_p('./tmp')
  results_file = File.expand_path('./tmp/results.txt')
  File.open(results_file, 'w+') do |f|
    File.readlines(file).each do |line|
      from, _to, _status = line.split(/\s/)
      next unless from && /\S/ =~ from

      from_uri = URI(from)
      headers = {}
      if url
        host = from_uri.hostname
        from_uri.hostname = url.hostname
        from_uri.scheme = url.scheme
        from_uri.port = url.port
        headers['X-TEST-HOST'] = host
      end

      request = Typhoeus::Request.new(from_uri, headers: headers)
      request.on_complete do |response|
        warn "GET #{headers} #{from_uri} => #{response.headers['Location']} #{response.code}"
        f.puts "#{from} #{response.headers['Location']} #{response.code}"
      end
      hydra.queue(request)
    end

    hydra.run
  end

  system("sort -uo #{results_file} #{results_file}", exception: true)
  system("git difftool --no-index -- #{file} #{results_file}", exception: true)
end

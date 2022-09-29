
redirects = File.readlines(WCC::UrlShortener.application.root.join('config/redirects'))

WCC::UrlShortener.application.middleware.insert_before Rack::Static,
  WCC::UrlShortener::RedirectRouter, redirects

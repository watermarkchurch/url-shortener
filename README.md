# Watermark URL shortener

[![CircleCI](https://dl.circleci.com/status-badge/img/gh/watermarkchurch/url-shortener/tree/master.svg?style=svg)](https://dl.circleci.com/status-badge/redirect/gh/watermarkchurch/url-shortener/tree/master)

This is a simple URL shortener based on Rack.  It reads the file in [`config/redirects`](./config/redirects)
and converts it into a set of regexes that are matched against incoming requests.
It then redirects to the appropriate destination based on the template.

This project replaced https://github.com/watermarkchurch/heroku-redirect and no longer
reads rules from environment variables like `RULE_1`.  Rules should be added to the
redirects file instead.

## Adding new redirects

Simply add the new line to the [`config/redirects`](./config/redirects) file, commit the change to the master
branch, and push.  Once CircleCI passes, the code will automatically be deployed to production by Heroku.

## Testing code changes

The heroku pipeline has review apps enabled, so any branch will automatically have
a review app created.  To test redirect matching by hostname, we inject the `WCC::UrlShortener::Middleware::TestHost` middleware, which reads the `X-Test-Host`
HTTP header.  So you can verify a redirect goes where you want by sending that header:

```
curl -I -XGET -H 'X-Test-Host: www.theporchdallas.com' https://wcc-url-shor-ruby-iltymgvzadzx.herokuapp.com

HTTP/1.1 301 Moved Permanently
Location: https://www.theporch.live/legacy
```

The `verify` rake task will verify a list of redirects go to the correct place.
It reads the `spec/fixtures/redirects.txt` file to get the expected list of
redirects, and then performs HTTP Get requests to those URLs.  If all the requests
redirect to the expected locations, then the rake task exits with code 0.  If not,
it will run your git difftool to show the differences.

Running `rake verify[$review_app_url]` will connect to your review app and send the
`X-Test-Host` header to verify that all the rules match properly.

Running `rake verify` without specifying a URL will check the production URLs without using the `X-Test-Host` header.

# Watermark URL shortener

This is a simple URL shortener based on Rack.  It reads the file in [`config/redirects`](./config/redirects)
and converts it into a set of regexes that are matched against incoming requests.
It then redirects to the appropriate destination based on the template.

This project replaced https://github.com/watermarkchurch/heroku-redirect and no longer
reads rules from environment variables like `RULE_1`.  Rules should be added to the
redirects file instead.

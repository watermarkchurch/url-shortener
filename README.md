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

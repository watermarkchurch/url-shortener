# Watermark URL shortener

This is a simple URL shortener based on Rack.  It reads the file in `config/redirects`
and converts it into a set of regexes that are matched against incoming requests.
It then redirects to the appropriate destination based on the template.


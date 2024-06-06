# frozen_string_literal: true

module WCC::UrlShortener::Util
  module_function

  def path_to_regexp(path)
    path = path.gsub(/\/?\*/, '(?<splat>[^\?]*)')
      .gsub(/:(\w+)/, '(?<\1>[^\/\?]+)')

    Regexp.new("^#{path}(?:\\?.*)?$")
  end
end

# frozen_string_literal: true

source 'https://rubygems.org'

ruby '3.3.1'

gem 'bugsnag', '~> 6.24'
gem 'puma', '~> 6.0'
gem 'rack', '~> 3.0'

group :development do
  gem 'guard', '~> 2.18'
  gem 'guard-rspec', '~> 4.7'
  gem 'guard-rubocop', '~> 1.5'
  gem 'rackup'
  gem 'rake'
  gem 'rubocop', '>= 1.46', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rspec', require: false
  gem 'typhoeus'
end

group :test do
  gem 'rack-test', '~> 2.0'
  gem 'rspec', '~> 3.11'
  gem 'rspec_junit_formatter', '~> 0.5.1'
  gem 'simplecov', '~> 0.21.2'
  gem 'simplecov-cobertura', '~> 2.1'
end

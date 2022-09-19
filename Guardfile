directories %w(config lib spec)

group :red_green_refactor, halt_on_fail: true do
  guard :rspec, cmd: 'bundle exec rspec --order rand --format documentation', all_on_start: false do
    require 'guard/rspec/dsl'
    dsl = Guard::RSpec::Dsl.new(self)

    # RSpec files
    rspec = dsl.rspec
    watch(rspec.spec_helper) { rspec.spec_dir }
    watch(rspec.spec_support) { rspec.spec_dir }
    watch(rspec.spec_files)

    # Ruby files
    ruby = dsl.ruby
    dsl.watch_spec_files_for(ruby.lib_files)

    # rake tasks
    watch(%r{lib/tasks/(.+).rake}) { |m| rspec.spec.call("tasks/#{m[1]}") }
  end

  guard :rubocop, cli: ['--display-cop-names'] do
    watch(%r{.+\.rb$})
    watch(%r{(?:.+/)?\.rubocop(?:_todo)?\.yml$}) { |m| File.dirname(m[0]) }
  end
end

group :autofix do
  guard :rubocop, all_on_start: false, cli: ['--auto-correct', '--display-cop-names'] do
    watch(%r{.+\.rb$})
    watch(%r{(?:.+/)?\.rubocop(?:_todo)?\.yml$}) { |m| File.dirname(m[0]) }
  end
end

scope group: :red_green_refactor

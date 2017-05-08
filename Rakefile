require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'

RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = '--tag ~needs_live_db2_server'
end

RuboCop::RakeTask.new

task default: [:spec, :rubocop]

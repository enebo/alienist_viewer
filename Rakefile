require "rspec/core/rake_task"

desc 'Run specs'
RSpec::Core::RakeTask.new(:spec) do |s|
  s.pattern = 'spec/web_spec.rb'
end

desc 'Run specs'
task :default => :spec

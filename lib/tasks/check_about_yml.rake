require 'rspec/core/rake_task'
require_relative '../../spec/about_yml_file_spec.rb'

desc 'Check your .about.yml file'
RSpec::Core::RakeTask.new(:run_about_yml_check) do |t|
  t.pattern = File.expand_path '../../../spec/about_yml_file_spec.rb', __FILE__
end

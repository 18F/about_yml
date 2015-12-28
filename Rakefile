require 'bundler/gem_tasks'
require 'rake/testtask'
import './lib/about_yml/tasks/check_about_yml.rake'

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.test_files = FileList['test/*test.rb']
end

desc 'Run .about.yml tests'
task default: :test
task test: :run_about_yml_check

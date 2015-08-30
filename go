#! /usr/bin/env ruby

require 'English'

Dir.chdir File.dirname(__FILE__)

def try_command_and_restart(command)
  exit $CHILD_STATUS.exitstatus unless system command
  exec RbConfig.ruby, *[$PROGRAM_NAME].concat(ARGV)
end

begin
  require 'bundler/setup' if File.exist? 'Gemfile'
rescue LoadError
  try_command_and_restart 'gem install bundler'
rescue SystemExit
  try_command_and_restart 'bundle install'
end

begin
  require 'go_script'
rescue LoadError
  try_command_and_restart 'gem install go_script' unless File.exist? 'Gemfile'
  abort "Please add \"gem 'go_script'\" to your Gemfile"
end

extend GoScript
check_ruby_version '2.2.3'

command_group :dev, 'Development commands'

def_command :update_gems, 'Update Ruby gems' do |gems = []|
  update_gems gems
end

def_command :test, 'Execute automated tests' do |args = []|
  exec_cmd "bundle exec rake test #{args.join ' '}"
end

def_command :lint, 'Run style-checking tools' do |files = []|
  lint_ruby files
end

def_command :ci_build, 'Execute continuous integration build' do
  test
  exec_cmd 'bundle exec rake build'
end

def_command :release, 'Test, build, and release a new gem' do
  test
  exec_cmd 'bundle exec rake release'
end

execute_command ARGV

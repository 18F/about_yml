# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'about_yml/version'

Gem::Specification.new do |s|
  s.name          = 'about_yml'
  s.version       = AboutYml::VERSION
  s.authors       = ['Mike Bland', 'Alison Rowland']
  s.email         = ['michael.bland@gsa.gov', 'alisonrowland@gmail.com']
  s.summary       = '.about.yml project metadata schema and tools'
  s.description   = (
    'The .about.yml mechanism allows an project to publish and maintain ' \
    'metadata that can be easily maintained by project owners, that is ' \
    'visible and accessible to interested parties, and that can be ' \
    'harvested and processed by tools and automated systems.'
  )
  s.homepage      = 'https://github.com/18F/about_yml'
  s.license       = 'CC0'

  s.files         = `git ls-files -z *.md bin lib`.split("\x0") + [
  ]
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }

  s.add_runtime_dependency 'safe_yaml', '~> 1.0'
  s.add_runtime_dependency 'octokit', '~> 3.0'
  s.add_runtime_dependency 'json-schema'
  s.add_development_dependency 'go_script', '~> 0.1'
  s.add_development_dependency 'rake', '~> 10.4'
  s.add_development_dependency 'minitest'
  s.add_development_dependency 'codeclimate-test-reporter'
  s.add_development_dependency 'coveralls'
  s.add_development_dependency 'rubocop'
end

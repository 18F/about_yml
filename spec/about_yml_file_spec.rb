require_relative '../lib/about_yml'

require 'rspec'
require 'safe_yaml'

RSpec.describe AboutYml::TemplateGenerator do
  it 'generates a valid template' do
    filepath = File.expand_path('../../.about.yml', __FILE__)
    about_file = File.join filepath
    about_data = SafeYAML.load_file about_file, safe: true
    errors = ::AboutYml::AboutFile.validate_single_file about_data
    expect(errors).to be_empty
  end
end

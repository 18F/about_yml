require_relative '../lib/about_yml'

require 'rspec'
require 'safe_yaml'

RSpec.describe AboutYml::AboutFile do
  it 'validates the .about.yml file against the schema' do
    filepath = File.expand_path('../../.about.yml', __FILE__)
    about_file = File.join filepath
    about_data = SafeYAML.load_file about_file, safe: true
    errors = ::AboutYml::AboutFile.validate_single_file about_data
    expect(errors).to be_empty
  end
end

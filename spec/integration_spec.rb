require_relative '../lib/about_yml'
require_relative '../lib/about_yml/data_faker'

require 'rspec'
require 'safe_yaml'

RSpec.describe AboutYml::TemplateGenerator do
  it 'generates a valid template' do
    faker = AboutYml::DataFaker.new
    errors = ::AboutYml::AboutFile.validate_single_file faker.template_data
    expect(errors).to be_empty
  end
end

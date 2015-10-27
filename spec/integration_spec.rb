require_relative '../lib/about_yml'

require 'rspec'
require 'safe_yaml'
require 'random_data'

RSpec.describe AboutYml::TemplateGenerator do
  it 'generates a valid template' do
    @generator = AboutYml::TemplateGenerator.new
    template = @generator.generate
    template_data = YAML.load template

    # load up the JSON schema to fill in appropriate values
    schema = AboutYml::AboutFile.schema

    @type_map = {
      'string' => lambda { Random.alphanumeric },
      'boolean' => lambda { Random.boolean },
    }

    # populate the template with random values according to their type
    # in the schema
    def fill_data(props)
      return unless props.key? 'type'
      type = props['type']

      return props['enum'].rand if props.key? 'enum'
      return fill_array props   if type == 'array'
      return fill_object props  if type == 'object'

      @type_map[type].call if @type_map[type]
    end

    def fill_array(props)
      subtype = props['items']['type']

      3.times.collect do
        if @type_map[subtype]
          @type_map[subtype].call
        else
          subprops = @generator.get_ref(props['items']['$ref'])
          fill_new_object subprops
        end
      end
    end

    def fill_object(props)
      if props.key? 'items'
        return fill_data @generator.get_ref(props['items']['$ref'])
      elsif props.key? 'patternProperties'
        # this is hacky, but will work unless the "licenses" patternProperties
        # are changed to include more than one pattern
        _, v = props['patternProperties'].shift
        subprops = @generator.get_ref(v['$ref'])

        # the patternProperties works by regex matching on the keys of the
        # sub-object, # so we need to create another level of nesting with
        # a random key
        return { Random.alphanumeric => fill_new_object(subprops) }
      end
    end

    def fill_new_object(props)
      new_obj = {}
      props.map { |k, _| new_obj[k] = fill_data props[k] }
      new_obj
    end

    # the main iterator
    template_data.each do |k, _|
      template_data[k] = fill_data schema['properties'][k]
    end

    errors = ::AboutYml::AboutFile.validate_single_file template_data
    expect(errors).to be_empty
  end
end

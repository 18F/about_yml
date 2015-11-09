# @author Alison Rowland (alison.rowland@gsa.gov)

require_relative 'about'
require 'safe_yaml'
require 'random_data'

module AboutYml
  class DataFaker
    attr_reader :template_data

    TYPE_MAP = {
      'string' => lambda { Random.alphanumeric },
      'boolean' => lambda { Random.boolean },
    }

    def initialize
      @generator = AboutYml::TemplateGenerator.new
      template = @generator.generate
      @template_data = YAML.load template

      # load up the JSON schema to fill in appropriate values
      schema = AboutYml::AboutFile.schema

      @template_data.collect do |k, _|
        @template_data[k] = fill_data schema['properties'][k]
      end
    end

    # populate the template with random values according to their type
    # in the schema
    def fill_data(props)
      return unless props.key? 'type'
      type = props['type']

      return props['enum'].rand if props.key? 'enum'
      return fill_array props   if type == 'array'
      return fill_object props  if type == 'object'

      TYPE_MAP[type].call if TYPE_MAP[type]
    end

    def fill_array(props)
      subtype = props['items']['type']

      3.times.collect do
        if TYPE_MAP[subtype]
          TYPE_MAP[subtype].call
        else
          subprops = @generator.definition_properties props['items']['$ref']
          fill_new_object subprops
        end
      end
    end

    def fill_object(props)
      if props.key? 'items'
        return fill_data @generator.definition_properties props['items']['$ref']
      elsif props.key? 'patternProperties'
        # this is hacky, but will work unless the "licenses" patternProperties
        # are changed to include more than one pattern
        _, v = props['patternProperties'].shift
        subprops = @generator.definition_properties v['$ref']

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
  end
end

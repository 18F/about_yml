# @author Mike Bland (michael.bland@gsa.gov)

require_relative 'about'
require 'json-schema'
require 'safe_yaml'

module AboutYml
  class TemplateGenerator
    attr_reader :schema, :properties, :required
    def initialize
      @schema = ::AboutYml::AboutFile.schema
      @properties = schema['properties']
      @required = schema['required']
    end

    def generate
      props = properties.map { |name, defn| generate_item name, defn }
      "---\n# #{schema['description']}\n#\n#{props.join "\n\n"}"
    end

    def get_ref(ref)
      definition_properties ref
    end


    private

    def generate_item(name, definition)
      "#{property_description name, definition}\n#{name}:" \
        "#{"\n- " if definition['type'] == 'array'}" \
        "#{"\n  placeholder_label:" if definition['patternProperties']}"
    end

    def property_description(name, definition)
      description = "# #{definition['description']}"
      description += ' (required)' if required.include? name
      description + value_description(definition)
    end

    def value_description(definition)
      values = definition['enum']
      return "\n# values: #{values.join ', '}" if values
      type = definition['type']
      return "\n# values: true, false" if type == 'boolean'
      return item_description definition if type == 'array'
      return pattern_desc definition if definition['patternProperties']
      ''
    end

    def item_description(definition)
      item_ref = definition['items']['$ref']
      return '' unless item_ref
      properties = definition_properties item_ref
      descs = properties.map { |name, defn| "#{name}: #{defn['description']}" }
      "\n# Items:\n# - #{descs.shift}\n#   #{descs.join "\n#   "}"
    end

    def pattern_desc(definition)
      property_descs = definition['patternProperties'].map do |prop_name, ref|
        descs = definition_properties(ref['$ref']).map do |defn_name, defn|
          "#{defn_name}: #{defn['description']}"
        end
        "\n#   #{prop_name}:\n#     #{descs.join "\n#     "}"
      end.join "\n"
      "\n# Items by property name pattern:#{property_descs}"
    end

    def definition_properties(item_ref)
      schema['definitions'][item_ref.split('/').last]['properties']
    end
  end
end

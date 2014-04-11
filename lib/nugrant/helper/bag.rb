require 'multi_json'
require 'yaml'

require 'nugrant/bag'

module Nugrant
  module Helper
    module Bag
      def self.read(filepath, filetype, options = {})
        data = parse_data(filepath, filetype, options)

        return Nugrant::Bag.new(data)
      end

      def self.restricted_keys()
        Bag.instance_methods
      end

      def self.parse_data(filepath, filetype, options = {})
        return if not File.exists?(filepath)

        File.open(filepath, "rb") do |file|
          return send("parse_#{filetype}", file)
        end
      rescue => error
        if options[:error_handler]
          options[:error_handler].handle("Could not parse the user #{filetype} parameters file '#{filepath}': #{error}")
        end
      end

      def self.parse_json(io)
        MultiJson.load(io.read())
      end

      def self.parse_yaml(io)
        YAML::ENGINE.yamler = 'syck' if (defined?(Syck) || defined?(YAML::Syck)) && defined?(YAML::ENGINE)

        YAML.load(io.read())
      end
    end
  end
end

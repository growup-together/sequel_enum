require 'hashr'

module Sequel
  module Plugins
    module Enum
      def self.apply(model, opts = OPTS)
      end

      module ClassMethods
        def enums
          @enums ||= Hashr.new
        end

        def enum(column, full_values)
          if full_values.is_a? Hash
            full_values.each do |key, val|
              fail ArgumentError, "value should be an integer, #{val} provided which it's a #{val.class}" unless val.is_a? Integer
            end
            values = full_values
          elsif full_values.is_a? Array
            values = Hash[full_values.map {|x| [x[0], x[2]] }]
          else
            fail ArgumentError, "#enum expects the second argument to be an array of symbols or a hash like { :symbol => integer }"
          end

          define_method "#{column}=" do |value|
            val = values.assoc(value.to_s.downcase)
            if val
              self[column] = val && val.last
            else
              fail 'invalid value is provided.'
            end
          end

          define_method column do
            val = values.rassoc(self[column])
            val && val.first
          end

          values.each do |key, value|
            define_method "#{key}?" do
              self.send(column) == key.to_s
            end
          end

          self.enums[column] = values
          self.enums["#{column}_keys".to_sym] = Hash[full_values.map {|x| [x[0].to_s.upcase, x[1]] }]
        end
      end
    end
  end
end

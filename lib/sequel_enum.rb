module Sequel
  module Plugins
    module Enum
      def self.apply(model, opts = OPTS)
      end

      module ClassMethods

        def enums
          @enums ||= {}
        end

        def enum(column, full_values)
          if full_values.is_a? Hash
            values.each do |key, val|
              fail ArgumentError, "value should be an integer, #{val} provided which it's a #{val.class}" unless val.is_a? Integer
            end
          elsif full_values.is_a? Array
            values = Hash[full_values.map {|x| [x[0], x[2]] }]
          else
            fail ArgumentError, "#enum expects the second argument to be an array of symbols or a hash like { :symbol => integer }"
          end

          define_method "#{column}=" do |value|
            val = self.class.enums[column].assoc(value.to_s)
            self[column] = val && val.last
          end

          define_method column do
            val = self.class.enums[column].rassoc(self[column])
            val && val.first
          end

          values.each do |key, value|
            define_method "#{key}?" do
              self.send(column) == key
            end
          end

          self.enums[column] = values
          self.enums["#{column}_array".to_sym] = full_values
          self.enums["#{column}_keys".to_sym] = Hash[full_values.map {|x| [x[0], x[1]] }]
        end
      end
    end
  end
end

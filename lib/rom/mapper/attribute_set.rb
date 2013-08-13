module ROM
  class Mapper

    # Represents a set of mapping attributes
    #
    # @private
    class AttributeSet
      include Enumerable, Concord.new(:header, :attributes), Adamantium

      def self.coerce(header, mapping = {})
        attributes = header.each_with_object({}) { |field, object|
          attribute = Attribute.coerce(field, mapping[field.name])
          object[attribute.name] = attribute
        }
        new(header, attributes)
      end

      # @api private
      def mapping
        each_with_object({}) { |attribute, hash|
          hash[attribute.tuple_key] = attribute.name
        }
      end
      memoize :mapping

      # @api private
      def keys
        # FIXME: find a way to simplify this
        header.keys.flat_map { |key_header|
          key_header.flat_map { |key|
            attributes.values.select { |attribute|
              attribute.tuple_key == key.name
            }
          }
        }
      end
      memoize :keys

      # @api private
      def each(&block)
        return to_enum unless block_given?
        attributes.each_value(&block)
        self
      end

      # @api private
      def [](name)
        attributes.fetch(name)
      end

    end # AttributeSet

  end # Mapper
end # ROM

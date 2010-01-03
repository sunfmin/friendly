module Friendly
  class Cache < Storage
    class Arbitrary < Cache
      def create(document)
        existing = cache.get(cache_key(document)) || []
        cache.set(cache_key(document), existing.push(document.id))
      end

      def update(document)
        old_key  = old_key(document)
        existing = cache.get(old_key)
        if existing
          existing.delete(document.id)
          cache.set(old_key, existing)
        end
        create(document)
      end

      protected
        def make_key(document, &block)
          key = [klass.name, version]
          fields.inject(key, &block).join("/")
        end

        def cache_key(document)
          make_key(document) { |key, f| key + [f, document.send(f)] }
        end

        def old_key(document)
          make_key(document) do |key, f|
            key + [f, get_original_or_current_value(document, f)]
          end
        end

        def get_original_or_current_value(document, field)
          document.attribute_changed?(field) ?
            document.attribute_was(field) : document.send(field)
        end
    end
  end
end

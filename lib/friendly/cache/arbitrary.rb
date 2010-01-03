module Friendly
  class Cache < Storage
    class Arbitrary < Cache
      def create(document)
        existing = cache.get(cache_key(document)) || []
        cache.set(cache_key(document), existing.push(document.id))
      end

      protected
        def cache_key(document)
          key = [klass.name, version]
          fields.each { |f| key.push(f, document.send(f)) }
          key.join("/")
        end
    end
  end
end

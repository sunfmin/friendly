module Friendly
  module Document
    module Benchmarking
      def save
        benchmark("Saved #{self.class.name} in :time.".green) { super }
      end

      def destroy
        benchmark("Destroyed #{self.class.name} in :time.".green) { super }
      end
    end
  end
end

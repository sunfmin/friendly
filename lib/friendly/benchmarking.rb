require 'active_support/core_ext/benchmark'

module Friendly
  module Benchmarking
    def benchmark(title, level = Logger::DEBUG)
      if logger.level <= level
        to_return = nil
        ms        = benchmark_klass.ms { to_return = yield }
        logger.add(level, title.gsub(/:time/, "(%.1fms)" % ms))
        to_return
      else
        yield
      end
    end

    protected
      def benchmark_klass
        @benchmark_klass ||= Benchmark
      end
  end
end

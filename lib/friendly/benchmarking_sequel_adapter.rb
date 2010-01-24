module Friendly
  module BenchmarkingSequelAdapter
    def self.included(klass)
      klass.class_eval do
        alias_method :_execute_without_benchmarking, :_execute
        alias_method :_execute, :_execute_with_benchmarking
      end
    end

    include Friendly::Logging
    include Friendly::Benchmarking

    def log_info(*args); end

    def _execute_with_benchmarking(sql, opts)
      benchmark([sql, ":time"].join(" ")) do
        _execute_without_benchmarking(sql, opts) { |conn| yield(conn) }
      end
    end
  end
end

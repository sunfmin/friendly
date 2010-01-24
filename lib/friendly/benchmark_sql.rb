require 'friendly/benchmarking_sequel_adapter'

Friendly.db.class.send(:include, Friendly::BenchmarkingSequelAdapter)

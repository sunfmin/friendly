require File.expand_path("../../spec_helper", __FILE__)

describe "Friendly::Benchmarking" do
  class BenchmarksStuff
    include Friendly::Benchmarking

    attr_reader :logger

    def initialize(logger, benchmark_klass)
      @logger          = logger
      @benchmark_klass = benchmark_klass
    end
  end

  describe "when the log level is debug" do
    before do
      @logger          = stub(:level => Logger::DEBUG, :add => true)
      @benchmark_klass = Class.new { def ms; yield; 5; end }.new
      @benchmarker     = BenchmarksStuff.new(@logger, @benchmark_klass)
      @return_value    = @benchmarker.benchmark("User created. :time") do
        5
      end
    end

    it "logs and substitutes the time in to the title" do
      @logger.should have_received(:add).
                      with(Logger::DEBUG, "User created. (5.0ms)")
    end

    it "returns the return value of the block" do
      @return_value.should == 5
    end
  end

  describe "when the log level is above debug" do
    before do
      @logger          = stub(:level => Logger::INFO, :add => true)
      @benchmarker     = BenchmarksStuff.new(@logger, stub)
    end

    it "benchmarks and logs" do
      ran = false
      @benchmarker.benchmark("User created.") { ran = true }
      ran.should be_true
    end

    it "returns the return value of the block" do
      @benchmarker.benchmark("User created.") { true }.should == true
    end
  end
end

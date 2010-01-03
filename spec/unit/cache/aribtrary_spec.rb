require File.expand_path("../../../spec_helper", __FILE__)

describe "Friendly::Cache::Arbitrary" do
  before do
    @klass     = stub(:name => "User")
    @memcached = stub(:set => nil, :get => nil)
    @fields    = [:name]
    @cache     = Friendly::Cache::Arbitrary.new(@klass, @fields, {}, @memcached)
    @id        = Friendly::UUID.new
    @doc       = stub(:name => "Bond", :id => @id)
    @key       = ["User", 0, "name", "Bond"].join("/")
  end

  describe "#create" do
    describe "when there's nothing else in the cache" do
      before do
        @cache.create(@doc)
      end

      it "sets an array with the id of the object to an appropriate cache key" do
        @memcached.should have_received(:set).with(@key, [@id])
      end
    end

    describe "when there's something else in the cache" do
      before do
        @other_id = Friendly::UUID.new
        @memcached.stubs(:get).with(@key).returns([@other_id])
        @cache.create(@doc)
      end

      it "adds the object to the array" do
        key = ["User", 0, "name", "Bond"].join("/")
        @memcached.should have_received(:set).with(key, [@other_id, @id])
      end
    end
  end
end

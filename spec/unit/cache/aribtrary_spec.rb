require File.expand_path("../../../spec_helper", __FILE__)

describe "Friendly::Cache::Arbitrary" do
  def cache_key(name)
    ["User", 0, "name", name].join("/")
  end

  before do
    @klass     = stub(:name => "User")
    @memcached = stub(:set => nil, :get => nil)
    @fields    = [:name]
    @cache     = Friendly::Cache::Arbitrary.new(@klass, @fields, {}, @memcached)
    @id        = Friendly::UUID.new
    @doc       = stub(:name => "Bond", :id => @id)
    @key       = cache_key("Bond")
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
        @memcached.should have_received(:set).with(@key, [@other_id, @id])
      end
    end
  end

  describe "#update" do
    before do
      @new_key = cache_key("James")
      @doc = stub(:name    => "James", :attribute_was => "Bond", 
                  :changed => [:name], :id            => @id,
                  :attribute_changed? => true)
    end

    describe "when there's already something in cache" do
      before do
        @memcached.stubs(:get).with(@key).returns([@id])
        @cache.update(@doc)
      end

      it "removes the object from the cache index it used to be in" do
        @memcached.should have_received(:set).with(@key, [])
      end

      it "adds the object from the new cache key" do
        @memcached.should have_received(:set).with(@new_key, [@id])
      end
    end

    describe "when there's nothing in cache already" do
      before do
        @cache.update(@doc)
      end

      it "adds the object from the new cache key" do
        @memcached.should have_received(:set).once
        @memcached.should have_received(:set).with(@new_key, [@id])
      end
    end
  end

  describe "#delete" do
    before do
      @doc = stub(:name    => "James", :attribute_was => "Bond", 
                  :changed => [:name], :id            => @id,
                  :attribute_changed? => true)
      @key = cache_key("James")
    end

    describe "when there's something in the cache" do
      before do
        @memcached.stubs(:get).with(@key).returns([@doc.id])
        @cache.destroy(@doc)
      end

      it "deletes the item from the cache" do
        @memcached.should have_received(:set).with(@key, [])
      end
    end

    describe "when there's nothing in the cache" do
      before do
        @memcached.stubs(:get).with(@key).returns(nil)
        @cache.destroy(@doc)
      end

      it "does nothing" do
        @memcached.should have_received(:set).never
      end
    end
  end
end

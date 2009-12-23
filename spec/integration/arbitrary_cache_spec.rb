require File.expand_path("../../spec_helper", __FILE__)

describe "When an arbitrary field is cached" do
  def cache_key(user)
    "PhoneNumber/user_id/#{user.id.to_guid}"
  end

  describe "reading" do
    before do
      @user         = User.create
      @phone_number = PhoneNumber.create
      $cache.set(cache_key(@user), [@phone_number])
    end

    it "looks up the objects in the cached index" do
      PhoneNumber.first(:user_id => @user.id).should == @phone_number
      PhoneNumber.all(:user_id => @user.id).should == [@phone_number]
    end
  end

  describe "writing" do
    before do
      @user          = User.create
      @phone_number  = PhoneNumber.create(:user_id => @user.id)
      @phone_number2 = PhoneNumber.create(:user_id => @user.id)
    end

    it "stores an index of objects in the cache" do
      $cache.get(cache_key(@user)).should == [@phone_number.id, @phone_number2.id]
    end
  end
end

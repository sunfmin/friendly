require File.expand_path("../../spec_helper", __FILE__)

describe "An attribute with a default value" do
  before do
    @user = User.new
  end

  it "has the value by default" do
    @user.happy.should be_true
  end
end

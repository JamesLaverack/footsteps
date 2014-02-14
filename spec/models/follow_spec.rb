require 'spec_helper'

describe Follow do

  before(:each) do
    @user1 = FactoryGirl.create(:user)
    @user2 = FactoryGirl.create(:user, :name => "Bob", :email => "bob@example.com")
  end

  it "should reject not having a from field" do
    no_to = Follow.new(:to => @user2)
    no_to.should_not be_valid
  end

  it "should reject not having a to field" do
    no_from = Follow.new(:from => @user1)
    no_from.should_not be_valid
  end

  it "should create a relation between two users" do
    follow = Follow.new(:from => @user1, :to => @user2)
  end
end

require 'spec_helper'

describe User do

  before(:each) do
    @attr = FactoryGirl.attributes_for(:user)
  end

  it "should create an instance given valid attributes" do
    User.create!(@attr)
  end

  it "should require an email address" do
    no_email = User.new(@attr.merge(:email => ""))
    no_email.should_not be_valid
  end

  it "should require a name" do
    no_email = User.new(@attr.merge(:email => ""))
    no_email.should_not be_valid
  end

  it "should reject an invalid email address" do
    invalid_email = User.new(@attr.merge(:email => "foo@"))
    invalid_email.should_not be_valid
  end

  it "should reject duplicate email addresses" do
    User.create!(@attr)
    attr2 = FactoryGirl.attributes_for(:user)
    attr2.merge(:email => @attr[:email])
    duplicate_email = User.new(attr2)
    duplicate_email.should_not be_valid
  end

  it "should reject duplicate email addresses though case" do
    User.create!(@attr)
    attr2 = @attr
    attr2.merge(:email => @attr[:email].upcase)
    duplicate_email = User.new(attr2)
    duplicate_email.should_not be_valid
  end

 it "should reject duplicate names" do
    User.create!(@attr)
    attr2 = FactoryGirl.attributes_for(:user)
    attr2.merge(:name => @attr[:name])
    duplicate_email = User.new(attr2)
    duplicate_email.should_not be_valid
  end

  it "should reject duplicate email addresses though case" do
    User.create!(@attr)
    attr2 = @attr
    attr2.merge(:name => @attr[:name].upcase)
    duplicate_email = User.new(attr2)
    duplicate_email.should_not be_valid
  end

end

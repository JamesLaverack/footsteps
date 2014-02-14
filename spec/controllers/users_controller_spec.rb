require 'spec_helper'

describe UsersController do

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end
  end

  describe "GET 'show'" do
    it "returns http success" do
      user = FactoryGirl.create(:user)
      get 'show', { :id => user[:id] }
      response.should be_success
    end
  end

  describe "POST 'follow'" do
    it "returns http success" do
      user = FactoryGirl.create(:user)
      get 'follow', { :id => user[:id] }
      response.should be_success
    end
  end

  describe "POST 'unfollow'" do
    it "returns http success" do
      user = FactoryGirl.create(:user)
      get 'unfollow', { :id => user[:id] }
      response.should be_success
    end
  end

end

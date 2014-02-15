require 'spec_helper'

describe UsersController do

  before :each do
    sign_out :user
  end

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
      post 'follow', { :id => user[:id] }
      response.should be_redirect
    end
  end

  describe "POST 'unfollow'" do
    it "returns http success" do
      user = FactoryGirl.create(:user)
      post 'unfollow', { :id => user[:id] }
      response.should be_redirect
    end
  end

end

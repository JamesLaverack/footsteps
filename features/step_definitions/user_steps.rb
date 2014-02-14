def record_user(user)
  if not defined? @users
    @users = Array.new
  end
  @users << user
  return user
end

def sign_up(attrs)
  visit "/users/sign_up"
  fill_in "Name", :with => attrs[:name]
  fill_in "Email", :with => attrs[:email]
  fill_in "Password", :with => attrs[:password]
  fill_in "Password confirmation", :with => attrs[:password]
  click_button "Sign up"
end

When(/^I look at the list of users$/) do
  visit "/users"
end

Given(/^I exist as a user$/) do
  @user = FactoryGirl.create(:user)
  record_user(@user)
end

Given(/^there is another user$/) do
  @other_user = FactoryGirl.build(:user)
  @other_user[:name] = "James Blogs"
  @other_user[:email] = "james@blogs.com"
  @other_user.save
  record_user(@other_user)
end

Then(/^I should see that I am not following that user$/) do
  find('#following').should_not have_content(@other_user[:name])
end

Then(/^I should see that I am following that user$/) do
  find('#following').should_not have_content(@other_user[:name])
end

Then(/^I should see that user following me$/) do
  find('#followers').should have_content(@other_user[:name])
end

Then(/^I should see that that user is not following me$/) do
  find('#followers').should_not have_content(@other_user[:name])
end

Given(/^I am following that user$/) do
  FactoryGirl.create(:follow, :from => @user[:id], :to => @other_user[:id])
end

Given(/^that user is following me$/) do
  FactoryGirl.create(:follow, :from => @other_user[:id], :to => @user[:id])
end

Given(/^There are users$/) do
  @user = FactoryGirl.create(:user)
  record_user(@user)
end

Then(/^I should see all users$/) do
  @users.each do |user|
    page.should have_content user.name
  end
end

When(/^I look at my profile$/) do
  visit "/users/" + @user.id
end

When(/^I sign in$/) do
  attrs = FactoryGirl.attributes_for(:user)
  visit '/users/sign_in'
  fill_in "Email", :with => attrs[:email]
  fill_in "Password", :with => attrs[:password]
  click_button "Sign in"
end

Then(/^I should be signed in$/) do
  visit '/'
  page.should have_content "Sign out"
end

Given(/^I am not logged in$/) do
  # This ugly hack is here because we need to sign out using a HTTP DELETE
  # We can make Devise use a GET instead of a DELETE to sign out, but I'd
  # rather change my test to suit my program rather than my program to
  # suit my test.
  page.driver.submit :delete, "/users/sign_out", {}
end

When(/^I sign up with valid data$/) do
  sign_up(FactoryGirl.attributes_for(:user))
end

When(/^I sign up with an invalid email$/) do
  attrs = FactoryGirl.attributes_for(:user)
  attrs[:email] = "bob"
  sign_up(attrs)
end

Then(/^I should see a successful sign up message$/) do
  page.should have_content "signed up"
end

Then(/^I should see a failure about my email$/) do
  page.should have_content "Email is invalid"
end

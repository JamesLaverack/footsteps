def create_user
  user = FactoryGirl.create(:user)
  @users >> user
  return user
end

def sign_up(attrs)
  visit "/users/sign_up"
  fill_in "Name", :with => attrs[:name]
  fill_in "Email", :with => attrs[:email]
  fill_in "Password", :with => attrs[:password]
  fill_in "Password confirmation", :with => attr[:password]
  click_button "Sign up"
end

When(/^I look at the list of users$/) do
  visit "/users"
end

Given(/^there is another user$/) do
  @other_user = create_user
end

Then(/^I should see that I am not following that user$/) do
  pending # express the regexp above with the code you wish you had
end

Given(/^I am following that user$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^I should see that I am following that user$/) do
  pending # express the regexp above with the code you wish you had
end

Given(/^that user is following me$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^I should see that user following me$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^I should see that that user is not following me$/) do
  pending # express the regexp above with the code you wish you had
end

Given(/^There are users$/) do
  10.times do create_user end
end

Then(/^I should see all users$/) do
  @users.each do |user|
    page.should have_content(user.name)
  end
end

Given(/^I exist as a user$/) do
  @user = create_user
end

When(/^I look at my profile$/) do
  visit "/users/" + @user.id
end

When(/^I sign in$/) do
  visit '/'
  
end

Then(/^I should be signed in$/) do
  pending # express the regexp above with the code you wish you had
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
  attrs[:email] = ""
  sign_up(attrs)
end

Then(/^I should see a successful sign up message$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^I should see a failure about my email$/) do
  pending # express the regexp above with the code you wish you had
end

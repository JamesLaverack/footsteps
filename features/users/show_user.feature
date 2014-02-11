Feature: Show Users
	 As a visitor to the website
	 I want to view the users and their relations to each other
	 so I can see who follows who

	 Scenario: Viewing all users
	 Given There are users
	 When I look at the list of users
	 Then I should see all users

	 Scenario: Viewing users that I'm not following
	 Given I exist as a user
	 And there is another user
	 When I look at my profile
	 Then I should see that I am not following that user

	 Scenario: Viewing people I follow
	 Given I exist as a user
	 And there is another user
	 And I am following that user
	 When I look at my profile
	 Then I should see that I am following that user

	 Scenario: Viewing people following me
	 Given I exist as a user
	 And there is another user
	 And that user is following me
	 When I look at my profile
	 Then I should see that user following me

	 Scenario: Unfollowing someone
	 Given I exist as a user
	 And there is another user
	 And I am following that user
	 When I look at my profile
	 And I click "unfollow"
	 And I look at my profile
	 Then I should see that that user is not following me

	 Scenario: Following someone
	 Given I exist as a user
	 And there is another user
	 When I look at my profile
	 And I click "follow"
	 And I look at my profile
	 Then I should see that I am following that user
	 
	 
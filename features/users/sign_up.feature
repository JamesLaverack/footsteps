Feature: Sign up
	In order to follow people and be followed
 	As a user
	I want to be able to sign up

	Background:
		Given I am not logged in

	Scenario: User signs up with valid data
		When I sign up with valid data
		Then I should see a successful sign up message

	Scenario: User singns up with invalid email
		When I sign up with an invalid email
		Then I should see a failure about my email

	Scenario: User singns up with invalid email
		When I sign up with an invalid email
		Then I should see a failure about my email
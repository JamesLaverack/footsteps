Feature: Sign in
	In order to follow other users
	As a user
	I want to be able to sign in

	Background:
		Given: I am not logged in

	Scenario: A user signs in with valid data
		Given I exist as a user
		When I sign in
		Then I should be signed in
	
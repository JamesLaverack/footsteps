#Introduction
I started by doing research, seeing how the commmon problems presented are solved, from this and what I knew before I decided on what gems to use to help me. The main one being Devise, but I'll get to that when building the user model itself.
To begin with it's mostly houskeeping. Create a new RVM gemset against Ruby 2.1.0 and install the latest rails, getting version 4.0.2. After that I need to just create the rails app.

   rails new footsteps -T

I'm using the `-T` flag to not generate test files. This sounds dumb, but I've decided to use a different set of testing tools. This brings me nicely onto the subject. Before creating a single model I need to write some tests.

I've decided to go with a combination of Cucumber and RSpec. The former for 'full-stack' interation testing, that is testing that the enitre application works as expected from a user's point of view. The latter is for unit testing, ensuring that individual components have tests.

I'll write the unit tests as I make controllers and models, but the cucumber tests I'll write now. Broadly speaking these tests describe the behaviour of the application. If the tests pass, the application works as we want it to in at least one case.

So, after putting this innital state in git, I'll put the gem `cucumber-rails` along with `database_cleaner`, `factory_girl_rails`, and `capybara` in my Gemfile under the test group and do a `bundle install` to get it insalled.

The second of those gems does what it says on the tin and we'll also be using it with RSpec later. Capybara works together with Cucumber to make testing our site as if we are a user really easy, and factory-girl makes forming default data nice and simple. Finally, a quick `rails g cucumber:install` and we're ready to go.

The first step in writing cucumber tests is to write the features, these are written in a domain spesific language called Gherkin. We can treat it as plain-text-but-not-quite though. Conveniantly enough the task email specifies, in plain text, how the application should behave.

    1) Create a simple Rails 4 application.

    Create models that allow a user to follow another user.
    Allow a user to specify their name.
    Allow users to login to the application using their email address and a password.

    2) Create an interface that accepts post requests that allows users to “follow” other users.
    The user’s “index” action should list all of the users.
    The user’s “show” action should show:
    1) The user’s name
    2) The users the user is currently following (with a button to remove that following)
    3) The users the user is not following (with a button to add that following)
    4)  The users currently following this user

This is all talking about the user, so let's make a feature for looking at a user in `features/user/user_show.feature`. Here is also the point where I have to start making design decisions about the model, so I know how I can test it. I know that a user will have a name, an email, and a password. The email address should be unique as it's what the user uses to login, but should the name?

I've decided to make it unique too. This is so it's easier to tell users apart. Some arbitary ID number isn't very membirable, and it's bad form for a website to give out email addresses, so users require some way of telling two users with the same name appart. The simpilist solution is to enforce unique names. Another option would be some kind of identifier, like grabbing the gravitar avitar for the email and always displaying that next to the name, but that's also not gauranteed to be unique.

So, back to cucumber. We have some tests for viewing things. We also need to test creating users, logging in and logging out. We do this in `features/user/user_signup.feature` and `features/user/user_login.feature`.

Now that we have some tests we can start to implement them. We're going to need to setup factory_girl, and for that we're going to need to setup rspec so we can generate the spec directory. So we add the 'rspec-rails' gem, and another `bundle install` later we're golden. Once we've run `rails g rspec:install` anyway. For now though, we can't generate factories until we have a model.

One last bit of rspec setup, we need to configure it to use database-cleaner, the gem that will clean up our test database between each run to make sure we're running cleanly each time. To do that we need to open op `spec/spec_helper.rb` and set `use_transactional_fixtures` to be false. We also need to add some custom code into `spec/support/database_cleaner.rb`. It's pretty standard boilerplate, but see http://devblog.avdi.org/2012/08/31/configuring-database_cleaner-with-rails-rspec-capybara-and-selenium/ for the full details.

Right now we have the outline of some tests. If we run `rake cucumber` they tell us that our application doesn't work. Perfect. So it's now time to actually start to write the application that doesn't work, and then make it work. We'll start with the core, 'god object' of this entire project. The User model.

Before that though, we're going to use Devise. Devise is a gem designed to setup users for you, I'm using this because it's easy and why reinvent the wheel when someone has already written, tested and polished it for you. The main reason though is because writing your own password storage is a recipe for disaster. Cryptography is hard, and properly salting, hashing, and storing passwords is very easy to mess up if you write it yourself. So lets avoid that one as much as possible and let Devise do the heavy-lifting.

       rails g devise User

There we go, devise user model created. Time to write more tests.


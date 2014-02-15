#Introduction
I started by doing research, seeing how the commmon problems presented are solved, from this and what I knew before I decided on what gems to use to help me. The main one being Devise, but I'll get to that when building the user model itself. I tend to use a lot of Google to solve problems and find best practice, of particular note is the rails3-devise-rspec-cucumber tutorial on RailsApps. This was purely a 'best practices' referance. Not a template I built from.

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

So, back to cucumber. We have some tests for viewing things. We also need to test creating users, logging in and logging out. We do this in `features/user/user_signup.feature` and `features/user/user_login.feature`. Each cucumber feature should be in as plain english as possible, with minimal clutter. For example, it's preffered to say "Given I exist as a user" than "Given a user named James with email james@example.com exists".

Now that we have some tests we can start to implement them. We're going to need to setup factory_girl, and for that we're going to need to setup rspec so we can generate the spec directory. So we add the 'rspec-rails' gem, and another `bundle install` later we're golden. Once we've run `rails g rspec:install` anyway. For now though, we can't generate factories until we have a model.

One last bit of rspec setup, we need to configure it to use database-cleaner, the gem that will clean up our test database between each run to make sure we're running cleanly each time. To do that we need to open op `spec/spec_helper.rb` and set `use_transactional_fixtures` to be false. We also need to add some custom code into `spec/support/database_cleaner.rb`. It's pretty standard boilerplate, but see http://devblog.avdi.org/2012/08/31/configuring-database_cleaner-with-rails-rspec-capybara-and-selenium/ for the full details.

Right now we have the outline of some tests. If we run `rake cucumber` they tell us that our application doesn't work. Perfect. So it's now time to actually start to write the application that doesn't work, and then make it work. We'll start with the core, 'god object' of this entire project. The User model.

Before that though, we're going to use Devise. Devise is a gem designed to setup users for you, I'm using this because it's easy and why reinvent the wheel when someone has already written, tested and polished it for you. The main reason though is because writing your own password storage is a recipe for disaster. Cryptography is hard, and properly salting, hashing, and storing passwords is very easy to mess up if you write it yourself. So lets avoid that one as much as possible and let Devise do the heavy-lifting.

       rails g devise User

There we go, devise user model created. Time to write more tests. Devise has created for us an outline of a spec, along with a factory_girl factory. Lets play with that factory first. I'll modify it to generate a random name and email using Faker, a gem designed to spit out random names and email addresses. (Yes, there is a chance we could collide with an already generated one, but that's highly unlikely and I'll ofically worry about it later. For now, just run tests again if they fail because of a suspicious looking error about already existing users.)

Next I need to write the spec tests for the User model. This did end up being extermely strongly based on the example user spec from the tutorial I mentioned earlier. Another case of why do something when someone's already written it. The tests given there were not completely correct for our case however. This is certinally the most sagnificant case of lifting from the internet in this challange.

That's not to say it's a copy-paste job of course. In particular I have not used the test for accepting valid emails. This is mostly because I feel this is tested anyway when we try to create a valid instance given a valid set of attriubes from factory girl. Another change is actually using factory girl to produce default data. This means that everywhere in testing we reffer to factory girl to get example data.

Another strange consideration here is that we're, in a way, testing the same thing twice. In both Cucumber and RSpec we test a valid and invalid email address. The reason is we're testing different things. In RSpec we test that the model considers that invalid. In cucumber we test that this invalid state is communicated to the user. I've also chosen to ommit tests that were just testing the functionality of Devise. Testing our framework is unnessicary.

So, if we now run `rake cucumber` and `rake spec` we see that every single test fails. This is because our factory produces a set of default attributes with a name. The default user model has no idea what a name is and so errors instantly. Now it's time to actually begin writing the application that we have the tests to tell us doesn't work.

   rails g migration AddNameToUsers name:string

We can get rails to do that for us too though. A quick `rake db:migrate` later and RSpec now passes. Our model is fine. Cucumber however shows us a problem. Some things fail, we would expect this at this stage. However some things fail that I didn't expect.

As it happens, Faker has known issues working inside Cucumber. After some more thought, I also came to the conclusion that randomisation inside a test is a bad idea. Better to have something repeatable for sure. So I removed faker, and put in static data. I simply assigned different static data in a test when I needed it.

So, now my specs still pass and cucumber fails as I expect it to. A handful of specs that don't make sense yet (the code for following someone) are unimplemented, and a handful of code about logging in fails. What is going on? Well, it turns out I've messesd up my routes.rb file. I've told it to route root to `welcome#index`, but no controller named welcome exists. Time to fix that.

    rails g controller Welcome index

Another rails generator command and a bunch more cucumber scenarios pass. This has also written a blank controller and view spec. We don't need view specs as we're using Cucumber, and the controller spec already contains the only testing we care about - that it responds to the index action.

For now lets look at the next failure. This time we can't find the name field on the sign up form to input data into. So, without a name it should be impossible to create a user. If I run the rails server, and go plug in an email and a password it should fail as the user model requires a name, our spec tells us so right?

Turns out I'd made a mistake there too. I'd written that particular test incorrectly, so it was giving a false pass. A quick re-write and check of my other tests and I now have a failing spec. So lets fix that before anything else. We need the user model to require the presense of the name field. So it's time to open up `app/models/user.rb` and write some code.

We have three spec failures. Rejecting duplicate names, requiring a name, and rejecting a duplicate name given a different case. What we need is an ActiveRecord validation to assert these values of existance and uniqeness. After setting those in the model our spec passes again, this time actually correctly.

Back to cucumber, we still have the problem of no name field on the signup form. Currently we're using devise's built in controller and view to render the user intraction code. It's time to modify that.

     rails g devise:views

With that we now have all of the Devise views, ready to customise. In particular we're interested in the view "app/views/devise/registrations/new.html.erb". We can add the name field in here. We need to modify the controller too, to do that we add a filter in 'app/controllers/application_controller.rb', adding to the list of parameters that the uusers controller will pass though to the model.

After adding a register and sign in button to the layout, that change to a sign out button when signed in, I can write the validations to detect if we are signed in or not. Then we've got everything we need to make accounts and sign in. Helpfully, cucumber agrees, the sign up feature passing completely.

After a little bit of bugfixing here and there (as it happens, if you do FactoryGirl.create(:user), you can't ask the resulting object what it's password is. It's almost like we don't store a plaintext password at the model level!) with the tests and the application we have signing up, signing in and signing out working. It's time to tackle the index action.

By default, Devise does not support an indexing action to list all of the users, but we require it and our cucumber test for it is failing. So lets add that next.

   rails g controller Users index

This will create the Users controller with the index action. Then we just update the action to assign a list of all users, the view to list all of their names, and the routes file to assign this to `/users/index`. The autogenerated rspec test (that validates the index action produces a result) is sufficant as there is a cucumber test for listing all users. Which starts passing with no extra changes, success.

Next we need the concept of a profile page, and specifically a show action. So we'll go to the spec for the user controller and test that we have a show action. This will obviously fail, so lets make the show action. All we need to do is check the params hash for the :id of the user and look that up in the User model. We'll redirect to the root of the app with a notice that we can't find the user if the model returns nil. Otherwise we'll pass the user object as @user down to the view, which we'll make. The view is dead simple and just exposes the name and nothing else. 

This makes the URL for a profile something like `/users/3`, we could have instead chosen to use names like `/users/Sam`, but this brings in a whole load of case issues. We'd also need to exclude characters from names that are illegal URL characters, and special characters should be discouraged for being strange (e.g. '/users/ben%20smith' is ugly). So it's best to leave it as id's for now.

A few more edits to make. We'll add a link to my profile at the top of every page if you are logged in, this is a simple change to application.html.erb alongside the sign out link. We'll also edit the user index view to add a link to the profile of a user too.

Now we have a profile page it's fine to finish writing the cucumber tests. I've also written the code to follow someone, not that I have a follow relation yet. RSpec passes everything, and cucumber passes all but 5 senarios. The scnarios about following and unfollowing someone.

We need our second model now, a follow model.

   rails g scaffold Follow from:referances to:referances

I use a scaffold this time as I want a controller too, but I don't care about views so I'll delete those straight away along with their tests. I'll change the controler to expose only the :create and :delete actions, and restrict the routes so they are the only ones exposed. After updating the controller boilerplate spec to only test those two actions I run it only to find a lot of errors.

As it turns out, using the references datatype will stick an "_id" on the end of the column name. Normally what I want, but not in this case. After writing a rename migration and applying that everything is fine. Spec is now passing. We have also added a test case for the follows model spec, that both fields exist.

After a little more bugfixing we're at the state where almost all of the cucumber tests pass. The only thing left is the follow and unfollow links. It's at this point that I correct a lot of bugs in the follows model. This ends up changing the model so that it requires a user *object* to create the associations rather than just a user id. Now, I could adapt the follows controller to take in user ID's and do lookups, but it's becoming apparent that I don't really want a controller for it.

A liberal application of the rm command later and I don't have a follows controler, or tests for it. I just add a follow action to the user controler, using Devise to require you be logged in to use it, and if you are getting your current user to be the follow-er. I also add an extra test for it to the spec for the users controller.

The process from here is much as it has been before. Run the tests, see what doesn't pass, make it pass. After some fiddling with the User models to be able to correctly referance the followed and followers, all tests pass. One interesting part of this process was how to list users that I am not following. I thought about trying to construct some awful SQL mess to find this, but I realized that I could do it very esally. Get the list of all users, subtract the list of users who I'm following and the current user. Done.


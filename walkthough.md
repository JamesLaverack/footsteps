#Introduction
I started by doing research, seeing how the commmon problems presented are solved, from this and what I knew before I decided on what gems to use to help me. The main one being Devise, but I'll get to that when building the user model itself.
To begin with it's mostly houskeeping. Create a new RVM gemset against Ruby 2.1.0 and install the latest rails, getting version 4.0.2. After that I need to just create the rails app.

   rails new footsteps -T

I'm using the `-T` flag to not generate test files. This sounds dumb, but I've decided to use a different set of testing tools. This brings me nicely onto the subject. Before creating a single model I need to write some tests.

I've decided to go with a combination of Cucumber and RSpec. The former for 'full-stack' interation testing, that is testing that the enitre application works as expected from a user's point of view. The latter is for unit testing, ensuring that individual components have tests.

I'll write the unit tests as I make controllers and models, but the cucumber tests I'll write now. Broadly speaking these tests describe the behaviour of the application. If the tests pass, the application works as we want it to in at least one case.

So, after putting this innital state in git, I'll put the gem `cucumber-rails` along with `database_cleaner`, `therubyracer`, `factory_girl_rails`, and `capybara` in my Gemfile under the test group and do a `bundle install` to get it insalled.

The second of those gems does what it says on the tin and we'll also be using it with RSpec later. Therubyracer is a javascript runtime we'll need to test any JS we might include (and compile any coffeescript that might be used later), capybara works together with Cucumber to make testing our site as if we are a user really easy, and factory-gril makes forming default data nice and simple. Finally, a quick `rails g cucumber:install` and we're ready to go.

The first step in writing cucumber tests is to write the features, these are written in a domain spesific language called Gherkin. We can treat it as plain-text-but-not-quite though. 

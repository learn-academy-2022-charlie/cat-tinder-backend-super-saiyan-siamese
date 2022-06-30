# Setting up the Backend
```
$ rails new cat-tinder-backend -d postgresql -T
$ cd cat-tinder-backend
$ rails db:create
$ bundle add rspec-rails
$ rails generate rspec:install
```
- Add the remote from your GitHub classroom repository
- Create a default branch (main)
- Make an initial commit to the repository
```
$ rails server
```

# Cat Resource
```
$ rails generate resource Cat name:string age:integer enjoys:text image:text
$ rails db:migrate
```

# Initial Check
Run RSpec just to make sure the test works.
```
$ rspec spec
```
It should fail because we didn't actually make any tests.

# Plant some Cats
> file path: db/seeds.rb
```
cats = [
  {
    name: 'Ketchup',
    age: 2,
    enjoys: 'Supressing fire on an enemy position.',
    image: 'https://thiscatdoesnotexist.com/'
  },
  {
    name: 'Pickles',
    age: 12,
    enjoys: 'Giving 8-digit grids coordinates for accurate indirect fire.',
    image: 'https://thiscatdoesnotexist.com/'
  },
  {
    name: 'Relish',
    age: 5,
    enjoys: 'Relish.',
    image: 'https://thiscatdoesnotexist.com/'
  }
]

cats.each do |each_cat|
  Cat.create each_cat
  puts "creating cat #{each_cat}"
end
```

Run the seed to generate a entries into the database:
```
$ rails db:seed
```

# API CORS
> file path: app/controllers/application_controller.rb
This will disable the authenticity token while we develop the app.
```
class ApplicationController < ActionController::Base
    skip_before_action :verify_authenticity_token
  end
```

> file path: Gemfile
added to bottom:
```
# installing CORS so the front and back ends can talk to each other.
gem 'rack-cors', :require => 'rack/cors'
```

> create file path: config/initializers/cors.rb
```
# Avoid CORS issues when API is called from the frontend app.
# Handle Cross-Origin Resource Sharing (CORS) in order to accept cross-origin AJAX requests.

# Read more: https://github.com/cyu/rack-cors

Rails.application.config.middleware.insert_before 0, Rack::Cors do
    allow do
      origins '*'  # <- change this to allow requests from any domain while in development.
  
      resource '*',
        headers: :any,
        methods: [:get, :post, :put, :patch, :delete, :options, :head]
    end
  end
```
Run $ `bundle` in the terminal to update dependencies.
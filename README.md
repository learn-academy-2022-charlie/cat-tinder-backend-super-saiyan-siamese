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

# Spec Testing
> file path: spec/requests/cats_spec.rb
```
require 'rails_helper'

RSpec.describe "Cats", type: :request do
  describe "GET /index" do
    it "gets a list of cats" do
      Cat.create(
        name: 'Felix',
        age: 2,
        enjoys: 'Walks in the park',
        image: 'https://thiscatdoesnotexist.com/'
      )

      # Make a request
      get '/cats'

      cat = JSON.parse(response.body)
      expect(response).to have_http_status(200)
      expect(cat.length).to eq 1
    end
  end

  describe "POST /create" do
    it "creates a cat" do
      # The params we are going to send with the request
      cat_params = {
        cat: {
          name: 'Buster',
          age: 4,
          enjoys: 'Bustin.',
          image: 'https://thiscatdoesnotexist.com/'
        }
      }
  
      # Send the request to the server
      post '/cats', params: cat_params
  
      # Assure that we get a success back
      expect(response).to have_http_status(200)
  
      # Look up the cat we expect to be created in the db
      cat = Cat.first
  
      # Assure that the created cat has the correct attributes
      expect(cat.name).to eq 'Buster'
    end
  end
end
```

> file path: app/controllers/cats_controller.rb
```
class CatsController < ApplicationController

    def index
        cats = Cat.all
        render json: cats
    end
  
    def create
        # Create a new cat
        cat = Cat.create(cat_params)
        render json: cat
    end
  
    def update
    end
  
    def destroy
    end
  
    private
    def cat_params
      params.require(:cat).permit(:name, :age, :enjoys, :image)
    end

  end
  ```

   ## Update and Destroy endpoint testing
  >file path: spec/requests/cats_spec.rb
 
  ```ruby
describe "PATCH /update" do
    it "updates a cat" do
      # create an instance of Cat for the db
      Cat.create(
        name: 'Felix',
        age: 2,
        enjoys: 'Walks in the park',
        image: 'https://thiscatdoesnotexist.com/'
      )
      cat = Cat.first
      # The params we send to update the instance of cat
      update_cat_params = {
          cat: {
          name: 'Buster',
          age: 4,
          enjoys: 'Bustin.',
          image: 'https://thiscatdoesnotexist.com/'
        }
      }
      
  
      # Send the request to the server
      patch "/cats/#{cat.id}", params: update_cat_params
  
      # Assure that we get a success back
      expect(response).to have_http_status(200)
      #update cat will be assigned to the cat we updated
      update_cat = Cat.find(cat.id)
  
      # Assure that the created cat has the correct attributes
      # expect(cat.name).to eq 'Felix'
      expect(update_cat.name).to eq 'Buster'
    end
  end
  describe "Destroy /cats/:id" do
    it "destroys a cat from the database" do
      cat_params ={
        cat: {
          name: 'Buster',
          age: 4,
          enjoys: 'Bustin.',
          image: 'https://thiscatdoesnotexist.com/'
        }
      }
      post '/cats', params: cat_params
      buster = Cat.first
      buster_id = buster.id
      delete "/cats/#{buster_id}"
      expect(response).to have_http_status(200)
      expect(Cat.all.length).to eq 0
    end
  ```
>file path: app/controllers/cats_controller.rb
```ruby
    def update
      cat = Cat.find(params[:id])
      cat.update(cat_params)
      render json: cat
    end
  
    def destroy
      cat = Cat.find(params[:id])
      cats = Cat.all
      cat.destroy
      render json: cats

    end
  
    private
    def cat_params
      params.require(:cat).permit(:name, :age, :enjoys, :image)
    end
```

# API Validations
## Model
> file path: app/models/cat.rb
```
class Cat < ApplicationRecord
    validates :name, :age, :enjoys, :image, presence: true
    validates :enjoys, length: {minimum: 10}
  end
```

> file path: spec/models/cat_spec.rb
```
require 'rails_helper'

RSpec.describe Cat, type: :model do
  it "should validate name" do
    cat = Cat.create(
    age: 2,
    enjoys: 'Walks in the park',
    image: 'https://thiscatdoesnotexist.com/')
    expect(cat.errors[:name]).to_not be_empty
  end
  it "should validate age" do
    cat = Cat.create(
      name: "Michaelton",
      enjoys: 'Walks in the park',
      image: 'https://thiscatdoesnotexist.com/')
    expect(cat.errors[:age]).to_not be_empty
  end
  it "should validate enjoys" do
    cat = Cat.create(
      name: "Michaelton",
      age: 5,
      image: 'https://thiscatdoesnotexist.com/')
    expect(cat.errors[:enjoys]).to_not be_empty
  end
  it "should validate if enjoys is at least 10 characters long" do
    cat = Cat.create(
      name: "Michaelton",
      age: 5,
      enjoys: "dying",
      image: 'https://thiscatdoesnotexist.com/')
    expect(cat.errors[:enjoys]).to_not be_empty
  end
  it "should validate image" do
    cat = Cat.create(
      name: "Michaelton",
      age: 5,
      enjoys: "long walks off short piers")
    expect(cat.errors[:image]).to_not be_empty
  end
end
```

## Request
> file path: spec/requests/cats_spec.rb
relevant code:
```
it "doesn't create a cat without a name" do
      cat_params = {
        cat: {
          age: 2,
          enjoys: 'Walks in the park',
          image: 'https://thiscatdoesnotexist.com/'
        }
      }
      # Send the request to the  server
      post '/cats', params: cat_params
      # expect an error if the cat_params does not have a name
      expect(response.status).to eq 422
      # Convert the JSON response into a Ruby Hash
      json = JSON.parse(response.body)
      # Errors are returned as an array because there could be more than one, if there are more than one validation failures on an attribute.
      expect(json['name']).to include "can't be blank"
    end

    it "doesn't create a cat without a age" do
      cat_params = {
        cat: {
          name: "Michaelton",
          enjoys: 'Walks in the park',
          image: 'https://thiscatdoesnotexist.com/'
        }
      }
      post '/cats', params: cat_params
      expect(response.status).to eq 422
      json = JSON.parse(response.body)
      expect(json['age']).to include "can't be blank"
    end

    it "doesn't create a cat without an enjoys entry" do
      cat_params = {
        cat: {
          name: "Michaelton",
          age: 5,
          image: 'https://thiscatdoesnotexist.com/'
        }
      }
      post '/cats', params: cat_params
      expect(response.status).to eq 422
      json = JSON.parse(response.body)
      expect(json['enjoys']).to include "can't be blank"
    end

    it "doesn't create a cat without an image" do
      cat_params = {
        cat: {
          name: "Michaelton",
          age: 5,
          enjoys: "long walks off short piers"
        }
      }
      post '/cats', params: cat_params
      expect(response.status).to eq 422
      json = JSON.parse(response.body)
      expect(json['image']).to include "can't be blank"
    end
```

> file path: app/controllers/cats_controller.rb
relevant code:
```
    def create
        cat = Cat.create(cat_params)
        if cat.valid?
        render json: cat
        else
          render json: cat.errors, status:422
        end
    end
```

> file path: spec/requests/cats_spec.rb
relevant code:
```
it "doesn't create a cat without a name" do
      cat_params = {
        cat: {
          age: 2,
          enjoys: 'Walks in the park',
          image: 'https://thiscatdoesnotexist.com/'
        }
      }
      # Send the request to the  server
      post '/cats', params: cat_params
      # expect an error if the cat_params does not have a name
      expect(response.status).to eq 422
      # Convert the JSON response into a Ruby Hash
      json = JSON.parse(response.body)
      # Errors are returned as an array because there could be more than one, if there are more than one validation failures on an attribute.
      expect(json['name']).to include "can't be blank"
    end

    it "doesn't create a cat without a age" do
      cat_params = {
        cat: {
          name: "Michaelton",
          enjoys: 'Walks in the park',
          image: 'https://thiscatdoesnotexist.com/'
        }
      }
      post '/cats', params: cat_params
      expect(response.status).to eq 422
      json = JSON.parse(response.body)
      expect(json['age']).to include "can't be blank"
    end

    it "doesn't create a cat without an enjoys entry" do
      cat_params = {
        cat: {
          name: "Michaelton",
          age: 5,
          image: 'https://thiscatdoesnotexist.com/'
        }
      }
      post '/cats', params: cat_params
      expect(response.status).to eq 422
      json = JSON.parse(response.body)
      expect(json['enjoys']).to include "can't be blank"
    end

    it "doesn't create a cat without an image" do
      cat_params = {
        cat: {
          name: "Michaelton",
          age: 5,
          enjoys: "long walks off short piers"
        }
      }
      post '/cats', params: cat_params
      expect(response.status).to eq 422
      json = JSON.parse(response.body)
      expect(json['image']).to include "can't be blank"
    end
```

# Development notes
Currently working on 
> file path: spec/requests/cats_spec.rb

Attempting to create spec looking for a 422 error if update validations are not met. Currently getting a 200 error, so either the spec is wrong or the route is wrong.
 - solved: Relevant code to follow:
 >File path: spec/models/cat_spec.rb
 ```ruby
  describe 'minimum length/useful information test' do
    it 'validates the minumum length of the cat name' do
      cat = Cat.create(
        name: "",
        age: 5,
        enjoys: "long walks off short piers",
        image: 'https://thiscatdoesnotexist.com/'
      )
      expect(cat.errors[:name]).to_not be_empty
    end
    it 'validates the minumum length of the cat age' do
      cat = Cat.create(
        name: "Michaelton",
        age: "",
        enjoys: "long walks off short piers",
        image: 'https://thiscatdoesnotexist.com/'
      )
      expect(cat.errors[:age]).to_not be_empty
    end
    it "should validate if enjoys is at least 10 characters long" do
      cat = Cat.create(
        name: "Michaelton",
        age: 5,
        enjoys: "dying",
        image: 'https://thiscatdoesnotexist.com/')
      expect(cat.errors[:enjoys]).to_not be_empty
    end
  end
 ```
>File Path: spec/requests/cats_spec.rb
```ruby
    it "doesn't update a cat to have a useless name" do
      Cat.create(
        name: 'Felix',
        age: 2,
        enjoys: 'Walks in the park',
        image: 'https://thiscatdoesnotexist.com/'
      )

      felix = Cat.first
      p felix
      edit_params = {
        cat: {
          name: '',
          age: 3,
          enjoys: 'Walks in the park',
          image: 'https://thiscatdoesnotexist.com/'
        }
      }
 
      patch "/cats/#{felix.id}", params: edit_params

      expect(response.status).to eq 422
      json = JSON.parse(response.body)
      expect(json['name']).to include "can't be blank"
    end

    it "doesn't update a cat to not have useful age information" do
      Cat.create(
        name: 'Felix',
        age: 2,
        enjoys: 'Walks in the park',
        image: 'https://thiscatdoesnotexist.com/'
      )

      felix = Cat.first
      p felix
      edit_params = {
        cat: {
          name: 'Felix',
          age: nil,
          enjoys: 'Walks in the park',
          image: 'https://thiscatdoesnotexist.com/'
        }
      }
 
      patch "/cats/#{felix.id}", params: edit_params

      expect(response.status).to eq 422
      json = JSON.parse(response.body)
      expect(json['age']).to include "can't be blank"
    end

    it "doesn't update a cat to not have useful enjoyment information" do
      Cat.create(
        name: 'Felix',
        age: 2,
        enjoys: 'Walks in the park',
        image: 'https://thiscatdoesnotexist.com/'
      )

      felix = Cat.first
      p felix
      edit_params = {
        cat: {
          name: 'Felix',
          age: 2,
          enjoys: 'Walks',
          image: 'https://thiscatdoesnotexist.com/'
        }
      }
 
      patch "/cats/#{felix.id}", params: edit_params

      expect(response.status).to eq 422
      json = JSON.parse(response.body)
      expect(json['enjoys']).to include "is too short (minimum is 10 characters)"
    end
```
>File Path:  app/models/cat.rb
```ruby
class Cat < ApplicationRecord
    validates :name, :age, :enjoys, :image, presence: true
    validates :name, length: {minimum: 1}
    validates :age, length: {minimum: 1}
    validates :enjoys, length: {minimum: 10}
  end
```

# Fetch

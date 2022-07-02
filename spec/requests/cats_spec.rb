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
          enjoys: 'Walks in the park',
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

  end

  describe "PATCH /update" do
    it "updates a cat" do
      # create an instance of Cat for the db
      Cat.create(
        name: 'Felix',
        age: 2,
        enjoys: 'Walks in the park',
        image: 'https://thiscatdoesnotexist.com/'
      )
      # The params we send to update the instance of cat
      update_cat_params = {
        cat: {
          name: 'Buster',
          age: 4,
          enjoys: 'Walks in the park',
          image: 'https://thiscatdoesnotexist.com/'
        }
      }
      cat = Cat.first
      cat_id = cat.id
      
      # Send the request to the server
      patch "/cats/#{cat.id}", params: update_cat_params
  
      # Assure that we get a success back
      expect(response).to have_http_status(200)
      #update cat will be assigned to the cat we updated
      update_cat = Cat.find(cat_id)
  
      # Assure that the created cat has the correct attributes
      # expect(cat.name).to eq 'Felix'
      expect(update_cat.name).to eq 'Buster'
    end
###################################   BELOW
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
######################################## ABOVE
  end
  describe "Destroy /cats/:id" do
    it "destroys a cat from the database" do
      cat_params ={
        cat: {
          name: 'Buster',
          age: 4,
          enjoys: 'Walks in the park',
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

  end
end
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

  end
end
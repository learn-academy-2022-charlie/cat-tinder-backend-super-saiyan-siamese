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

  # describe "PATCH /update" do
  #   it "updates a cat" do
  #     # create an instance of Cat for the db
  #     cat = Cat.create(
  #       name: 'Felix',
  #       age: 2,
  #       enjoys: 'Walks in the park',
  #       image: 'https://thiscatdoesnotexist.com/'
  #     )
      
  #     # The params we are going to send with the request
  #     cat_params = {
  #       cat: {
  #         name: 'Buster',
  #         age: 4,
  #         enjoys: 'Bustin.',
  #         image: 'https://thiscatdoesnotexist.com/'
  #       }
  #     }
  
  #     # Send the request to the server
  #     patch `/cats/#{cat.id}`, params: cat_params
  
  #     # Assure that we get a success back
  #     expect(response).to have_http_status(200)
  
  #     # Look up the cat we expect to be created in the db
  #     cat = Cat.first
  
  #     # Assure that the created cat has the correct attributes
  #     expect(cat.name).to eq 'Buster'
  #   end
  # end

end
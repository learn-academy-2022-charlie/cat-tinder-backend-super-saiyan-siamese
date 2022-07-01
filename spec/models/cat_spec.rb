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
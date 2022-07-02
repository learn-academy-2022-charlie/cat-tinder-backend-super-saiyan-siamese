# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

cats = [
  {
    name: 'Ketchup',
    age: 2,
    enjoys: 'Supressing fire on an enemy position.',
    image: 'https://i.ibb.co/KXW3V0h/saiyan1.jpg'
  },
  {
    name: 'Pickles',
    age: 12,
    enjoys: 'Giving 8-digit grid coordinates for accurate indirect fire.',
    image: 'https://i.ibb.co/XSNQS34/saiyan2.jpg'
  },
  {
    name: 'Relish',
    age: 5,
    enjoys: 'being the gross green topping on hotdogs',
    image: 'https://i.ibb.co/BzCJGK0/saiyan3.jpg'
  },
  {
    name: 'Mayo',
    age: 7,
    enjoys: 'maneuvering on pinned down enemies',
    image: 'https://i.ibb.co/TwCYRcF/saiyan4.jpg'
  },
  {
    name: 'Hot Sauce',
    age: 3,
    enjoys: 'being thrown down the stairs',
    image: 'https://i.ibb.co/nmBJWhL/saiyan5.jpg'
  }
]

cats.each do |each_cat|
  Cat.create each_cat
  puts "creating cat #{each_cat}"
end
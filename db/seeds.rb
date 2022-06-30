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
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

1.upto(1_000_000) do
  User.create!(
    first_name: FFaker::Name.first_name,
    last_name: FFaker::Name.last_name,
    age: (1..99).to_a.sample,
    email: FFaker::Internet.email
  )
end

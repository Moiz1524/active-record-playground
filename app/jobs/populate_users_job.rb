class PopulateUsersJob < ApplicationJob
  queue_as :default

  def perform(*args)
    1.upto(1_000_000) do
      user = User.create!(
        first_name: FFaker::Name.first_name,
        last_name: FFaker::Name.last_name,
        age: (1..99).to_a.sample,
        email: FFaker::Internet.email
      )

      puts "User created with id: #{user.id}"
    end
  end
end

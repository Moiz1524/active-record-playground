# Avoid: creating records in loop:
# 1.upto(1_000_000) do
#   user = User.create!(
#     first_name: FFaker::Name.first_name,
#     last_name: FFaker::Name.last_name,
#     age: (1..99).to_a.sample,
#     email: FFaker::Internet.email
#   )

#   puts "User created with id: #{user.id}"
# end

# Use: create records in bulk
# users_data = {}
# User.insert_all(users_data)

module Users
  class Create < BaseInteractor
    def call
      context.users = created_users
    rescue => e
      context.fail(error: e.message)
    end

    private

    def request_params
      context.request_params      
    end

    def created_users
      users = []
      if request_params[:way] == "each"
        context.queried_through = "each"
        1.upto(1000) do
          user = User.create!(
            first_name: FFaker::Name.first_name,
            last_name: FFaker::Name.last_name,
            age: (1..99).to_a.sample,
            email: FFaker::Internet.email
          )

          users << user
        end
      else
        context.queried_through = "insert_all"
        1.upto(1000) do
          users << {
            first_name: FFaker::Name.first_name,
            last_name: FFaker::Name.last_name,
            age: (1..99).to_a.sample,
            email: FFaker::Internet.email
          }

          User.insert_all(users)
        end
      end
      users   
    end
  end  
end
# Avoid: using map or collect directly on the collection produced by the Active Record:
# User.where(age: 30).map(&:email)

# Use: pluck to narrow the query to the database and reduce the time needed to pull the records:
# User.where(age: 30).pluck(:email)

module Users
  class SingleColumn < BaseInteractor
    def call
      users = request_params[:way] == "not_recommended" ? use_map : use_pluck
      context.users = users
    rescue => e
      context.fail(error: e.message)
    end
    
    private

    def request_params
      context.request_params
    end

    def use_map
      context.queried_through = :map
      User.where(age: 30).map(&:email)      
    end

    def use_pluck
      context.queried_through = :pluck
      User.where(age: 30).pluck(:email)      
    end
  end
end
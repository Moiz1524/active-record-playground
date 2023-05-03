# Avoid: doing with Ruby operations that can be performed on SQL level
# User.where(age: 51).select { |user| user.first_name.starts_with?('A') }.take(10)

# Use: SQL to perform actions for better performance
# User.where(age: 51).where("first_name LIKE '%A'").limit(10)

module Users
  class Operation < BaseInteractor
    def call
      context.users = processed_users
    rescue => e
      context.fail(error: e.message)
    end

    private

    def request_params
      context.request_params      
    end

    def processed_users
      if request_params[:way] == "ruby"
        context.queried_through = "ruby"
        User.where(age: (20..30).to_a).select { |user| user.first_name.starts_with?('A') }.take(10)
      elsif request_params[:way] == "sql"
        context.queried_through == "sql"
        User.where(age: (20..30).to_a).where("first_name LIKE '%A'").limit(10)
      end
    end
  end  
end
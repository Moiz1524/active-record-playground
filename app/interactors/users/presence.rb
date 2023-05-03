# Another simple yet tricky thing. Rails developers got used to use .present? or .blank? for checking the presence 
# of the data given variable or collection. However, calling these methods on Active Record’s collection can introduce performance problems.
# If you don’t want to mess up the performance, remember:

# Calling .exists? will trigger an SQL query even if records are already loaded into the memory
# Calling .present? or .blank? will load records into memory so use them only if you are doing something else with these records later on
# If you want to load the collection and check for its existence, use @collection.load.any?, @collection.load.none? or @collection.load.none?

module Users
  class Presence < BaseInteractor
    def call
      context.users_presence = users_presence?
    rescue => e
      context.fail(error: e.message)
    end

    private
    
    def request_params
      context.request_params
    end

    def users_presence?
      if request_params[:way] == "present"
        context.queried_through = "present"
        User.where(age: 30).present?
      elsif request_params[:way] == "collection.load"
        context.queried_through = "collection.load"
        User.where(age: 30).load.any?
      elsif request_params[:way] == "exists"
        context.queried_through = "exists"
        User.where(age: 30).exists?
      end
    end
  end  
end
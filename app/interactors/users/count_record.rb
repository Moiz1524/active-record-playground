# It’s enough for you to memorize the following:
# When you use length, it always loads all records into memory and then counts them
# Use count if you want to perform SQL count query as this method always does it even when you pulled the collection earlier
# size is the most flexible one as it performs SQL count query if records are not loaded in the memory and it counts the elements from memory when they are already loaded
# An additional advantage of using size is that you can benefit from using cache counters as Active Record handles them automatically.

module Users
  class CountRecord < BaseInteractor
    def call
      users_count = count_records_by_way
      context.users_count = users_count
    rescue => e
      context.fail(error: e.message)
    end

    private

    def request_params
      context.request_params      
    end

    def count_records_by_way
      case request_params[:way]
      when "length"
        context.queried_through = :length
        User.all.length
      when "count"
        context.queried_through = :count
        User.count
      else
        context.queried_through = :size
        User.all.size
      end
    end
  end  
end
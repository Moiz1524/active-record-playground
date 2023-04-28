# A playground where DB concepts are implemented via Active Record as ORM. Testing different optimization techniques here ..

class HomeController < ApplicationController
  def index; end

  def select_values_for_one_column
    @way = params[:way] || "not_recommended"

    @benchmark_report = Benchmark.bm do |x| 
      x.report('A') do 
        result = Users::SingleColumn.call(request_params: { way: @way })
        @users, @queried_through = result.users, result.queried_through
      end
    end.first
  end

  private

  def large_collection_of_records
    # Avoid: using each and all with Active Record queries that are designed to return many records:
    # User.all.each do |user|
    #   puts user.id
    # end

    # Use: find_each to pull records in batches. It won’t load all records into the database and you can 
    # use it like an ordinary each method to iterate through all items in the collection:

    User.find_each { |user| puts user.id }
  end

  # It’s enough for you to memorize the following:
  # When you use length, it always loads all records into memory and then counts them
  # Use count if you want to perform SQL count query as this method always does it even when you pulled the collection earlier
  # size is the most flexible one as it performs SQL count query if records are not loaded in the memory and it counts the elements from memory when they are already loaded
  # An additional advantage of using size is that you can benefit from using cache counters as Active Record handles them automatically.
  def counting_records
    # User.all.length
    # User.count
    # User.all.size
  end

  def creating_records
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
  end

  def ruby_or_sql_operations_on_data
    # Avoid: doing with Ruby operations that can be performed on SQL level
    # User.where(age: 51).select { |user| user.first_name.starts_with?('A') }.take(10)

    # Use: SQL to perform actions for better performance
    User.where(age: 51).where("first_name LIKE '%A'").limit(10)
  end

  # Another simple yet tricky thing. Rails developers got used to use .present? or .blank? for checking the presence 
  # of the data given variable or collection. However, calling these methods on Active Record’s collection can introduce performance problems.
  # If you don’t want to mess up the performance, remember:

  # Calling .exists? will trigger an SQL query even if records are already loaded into the memory
  # Calling .present? or .blank? will load records into memory so use them only if you are doing something else with these records later on
  # If you want to load the collection and check for its existence, use @collection.load.any?, @collection.load.none? or @collection.load.none?
  def check_record_presence?
    
  end

  def bang_methods_with_transactions
    # Using bang methods is extremely important when dealing with database transactions.

    # Avoid: using non-bang methods when dealing with transactions as transaction won’t be rollbacked when the record won’t be saved:
    # User.transaction do
    #   user = User.create(first_name: "Moiz", last_name: "Ali")
      # SomeService.call(user)
    # end

    # Use: bang methods to rollback the whole transaction in case of a problem. The whole idea behind the transactions is to achieve “all or nothing” state where all steps of the process are completed or none of them is performed:
    User.transaction do
      user = User.create!(first_name: "Moiz", last_name: "Ali")
      # SomeService.call(user)
    end
  end
end
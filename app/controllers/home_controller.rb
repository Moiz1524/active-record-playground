# A playground where DB concepts are implemented via Active Record as ORM. Testing different optimization techniques here ..

class HomeController < ApplicationController
  def index; end

  def large_collection_of_records
    
  end

  def select_values_for_one_column
    @way = params[:way] || "not_recommended"

    @benchmark_report = Benchmark.bm do |x| 
      x.report('A') do 
        result = Users::SingleColumn.call(request_params: { way: @way })
        @users, @queried_through = result.users, result.queried_through
      end
    end.first
  end

  def counting_records
    @way = params[:way] || "length"

    @benchmark_report = Benchmark.bm do |x|
      x.report('A') do
        result = Users::Count.call(request_params: { way: @way })
        @users_count, @queried_through = result.users_count, result.queried_through
      end
    end.first
  end

  def creating_records
    @way = params[:way] || "each"

    @benchmark_report = Benchmark.bm do |x|
      x.report('A') do
        result = Users::Create.call(request_params: { way: @way })
        @users, @queried_through = result.users, result.queried_through
      end
    end.first
  end
  
  def ruby_or_sql_operations
    @way = params[:way] || "ruby"
    
    @benchmark_report = Benchmark.bm do |x|
      x.report('A') do
        result = Users::Operation.call(request_params: { way: @way })
        @users, @queried_through = result.users, result.queried_through
      end
    end.first
  end

  def records_presence
    @way = params[:way] || "collection.load"

    @benchmark_report = Benchmark.bm do |x|
      x.report('A') do
        result = Users::Presence.call(request_params: { way: @way })
        @users_presence, @queried_through = result.users_presence, result.queried_through
      end
    end.first
  end

  def records_transactions; end

  def records_deletion; end
end
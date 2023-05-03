require 'sidekiq/web'

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "home#index"
  mount Sidekiq::Web => "/sidekiq"

  get "performance_bites/large_records_collection", to: "home#large_collection_of_records", as: :large_records_collection
  get "performance_bites/one_column", to: "home#select_values_for_one_column", as: :one_column
  get "performance_bites/counting_records", to: "home#counting_records", as: :counting_records
  get "performance_bites/bulk_insert", to: "home#creating_records", as: :bulk_insert
  get "performance_bites/ruby_vs_sql_operations", to: "home#ruby_or_sql_operations", as: :ruby_vs_sql_ops
  get "performance_bites/record_presence", to: "home#records_presence", as: :records_presence
  get "performance_bites/transactions", to: "home#records_transactions", as: :records_transactions
  get "performance_bites/records_deletion", to: "home#records_deletion", as: :records_deletion
end

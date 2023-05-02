require 'sidekiq/web'

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "home#index"
  mount Sidekiq::Web => "/sidekiq"

  get 'performance_bites/one_column', to: "home#select_values_for_one_column", as: :one_column
  get "performance_bites/counting_records", to: "home#counting_records", as: :counting_records
end

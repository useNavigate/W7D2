Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  root "users#index"
  #sign up page
  resources :users, only: [:new, :create, :show, :index]
  #log_in & log_out page
  resource :session, only: [:new, :create, :destroy]
end

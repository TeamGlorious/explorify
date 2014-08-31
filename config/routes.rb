Rails.application.routes.draw do

  resources :passwords
  root to: 'sites#index'
  resources :users

  # sessions routes
  get '/login' => 'sessions#new'
  post '/login' => 'sessions#create'

  delete '/logout' => 'sessions#destroy'
  get '/logout' => 'sessions#destroy'

  
end

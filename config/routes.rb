Rails.application.routes.draw do

  # sessions routes
  get '/' => 'sites#index'
  # post '/' => 'sessions#create'
  root to: 'sites#index'
  get "/about" => 'sites#about'
  get "/login" => "sessions#new"
  post "/login" => "sessions#create"

  delete '/logout' => 'sessions#destroy'
  get '/logout' => 'sessions#destroy'

  get '/trips/callback' => 'trips#authorize'

  resources :passwords
  resources :users
  resources :explorify
  resources :trips do
    resources :medias
  end

end

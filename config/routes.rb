Rails.application.routes.draw do

  # sessions routes
  get '/' => 'sites#index'
  # post '/' => 'sessions#create'
  root to: 'sites#index'
  get "/login" => "session#new"
  post "/login" => "session#create"

  delete '/logout' => 'sessions#destroy'
  get '/logout' => 'sessions#destroy'

  get '/trips/callback' => 'trips#authorize'
  get '/instagrams/session' => 'instagrams#session'

  resources :instagrams
  resources :passwords
  resources :users
  resources :explorify
  resources :trips do
    resources :medias
  end

end

Rails.application.routes.draw do

  # sessions routes
  get '/' => 'sessions#new'
  post '/' => 'sessions#create'
  root to: 'sessions#new'
  get "/login" => "session#new"
  post "/login" => "session#create"

  delete '/logout' => 'sessions#destroy'
  get '/logout' => 'sessions#destroy'

  get '/instagrams/callback' => 'instagrams#show'
  get '/instagrams/session' => 'instagrams#session'

  resources :instagrams
  resources :passwords
  resources :users
  resources :explorify

end

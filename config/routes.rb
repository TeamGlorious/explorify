Rails.application.routes.draw do

  # sessions routes
  get '/' => 'sessions#new'
  post '/' => 'sessions#create'
  root to: 'sessions#new'
  get "/login" => "session#new"
  post "/login" => "session#create"

  delete '/logout' => 'sessions#destroy'
  get '/logout' => 'sessions#destroy'


  resources :passwords
  resources :users
  resources :explorify

end

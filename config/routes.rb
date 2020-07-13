Rails.application.routes.draw do
  root "static_pages#home"

  resources :users

  # Google認証
  get '/auth/:provider/callback', to: 'sessions#create'
  get '/auth/failure', to: redirect('/')

  resources :sessions
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  get '/logout', to: 'sessions#destroy'
  # delete "/logout", to: "sessions#destroy"

  resources :feeds
  post "/sort", to: "feeds#sort"
end

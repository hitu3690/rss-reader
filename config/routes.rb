Rails.application.routes.draw do
  # root "static_pages#home"
  #
  # resources :users
  #
  # # Google認証
  get '/auth/:provider/callback', to: 'api/v1/sessions#create'
  # get '/auth/failure', to: redirect('/')
  #
  # resources :sessions
  # get "/login", to: "sessions#new"
  # post "/login", to: "sessions#create"
  # get '/logout', to: 'sessions#destroy'
  # # delete "/logout", to: "sessions#destroy"
  #
  # resources :feeds
  # post "/sort", to: "feeds#sort"
  #
  # namespace :api do
  #   namespace :v1 do
  #     resources :hello, only: [:index]
  #   end
  # end
  namespace :api do
    namespace :v1 do
      resources :users do
        collection do
          get :me
        end
      end
      resource :sessions
    end
  end
end

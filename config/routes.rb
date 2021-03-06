require 'sidekiq/web'

Rails.application.routes.draw do

  filter :locale

  root 'main#index'

  scope module: 'home' do
    resources :user_sessions, only: [:new, :create]
    resources :users, only: [:new, :create]
    get 'login' => 'user_sessions#new', :as => :login

    post 'oauth/callback' => 'oauths#callback'
    get 'oauth/callback' => 'oauths#callback'
    get 'oauth/:provider' => 'oauths#oauth', as: :auth_at_provider
  end

  namespace 'admin' do
    devise_for :users, ActiveAdmin::Devise.config
  end

  ActiveAdmin.routes(self)

  resources :flickr

  mount ApiFlashcards::Engine, at: '/api'
  mount Sidekiq::Web, at: '/sidekiq'

  scope module: 'dashboard' do
    resources :user_sessions, only: :destroy
    resources :users, only: :destroy
    post 'logout' => 'user_sessions#destroy', :as => :logout

    resources :cards do
      collection do
        get :parse_form
        post :parse_words
      end
    end

    resources :blocks do
      member do
        put 'set_as_current'
        put 'reset_as_current'
      end
    end

    put 'review_card' => 'trainer#review_card'
    get 'trainer' => 'trainer#index'

    get 'profile/:id/edit' => 'profile#edit', as: :edit_profile
    put 'profile/:id' => 'profile#update', as: :profile
  end
end

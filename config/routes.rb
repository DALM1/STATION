Rails.application.routes.draw do
  devise_for :users

  root to: "chat_rooms#index"

  resources :chat_rooms, only: [:index, :show, :new, :create, :destroy] do
    member do
      get 'join'
    end
    resources :posts, only: [:create]
  end

  resources :posts, only: [] do
    resources :thread_msgs, only: [:create]
  end

  resources :direct_messages, only: [:index, :create]
  resources :notifications, only: [:index]

  resources :users, only: [:show, :edit, :update] do
    member do
      get 'profile', to: 'users#show', as: :profile
      get 'edit', to: 'users#edit', as: :edit_profile
      patch 'update', to: 'users#update'
    end
  end
end

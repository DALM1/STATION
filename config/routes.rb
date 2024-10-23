Rails.application.routes.draw do
  devise_for :users
  root to: "chat_rooms#index"

  resources :chat_rooms, only: [:index, :show, :new, :create] do
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
end

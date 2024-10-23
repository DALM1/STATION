Rails.application.routes.draw do
  get 'direct_messages/index'
  get 'direct_messages/create'
  get 'thread_msgs/create'
  get 'posts/create'
  get 'chat_rooms/index'
  get 'chat_rooms/show'
  devise_for :users
  root to: "chat_rooms#index"

  resources :chat_rooms, only: [:index, :show] do
    resources :posts, only: [:create]
  end

  resources :posts, only: [] do
    resources :thread_msgs, only: [:create]
  end

  resources :direct_messages, only: [:index, :create]
  resources :notifications, only: [:index]
end

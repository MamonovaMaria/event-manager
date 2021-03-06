Rails.application.routes.draw do
  devise_for :users
  root to: 'home#index'
  get '/home', to: 'home#index', as: :home
  get 'users/:id' => 'users#show'
  get '/order/assist' => 'orders#assist'
  resources :events
  resources :rooms
  resources :orders
  resources :users
end

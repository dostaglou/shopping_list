Rails.application.routes.draw do
  devise_for :users

  resources :lists do
    resources :items, except: [:destroy]
  end

  resources :friendships
  resources :items, only: [:destroy]

  post '/items/:id/update_status', to: "items#update_status", as: "item_update_status"
  put '/lists/:id/update_position', to: 'lists#update_position', as: 'list_update_position'

  root "lists#index"
end

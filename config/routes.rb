Rails.application.routes.draw do
  devise_for :users

  resources :lists do
    resources :items, except: [:destroy]
  end

  resources :items, only: [:destroy]

  put '/lists/:id/update_position', to: 'lists#update_position', as: 'list_update_position'

  root "lists#index"
end

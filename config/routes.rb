Rails.application.routes.draw do
  devise_for :users

  resources :lists
  put '/lists/:id/update_position', to: 'lists#update_position', as: 'list_update_position'

  root "lists#index"
end

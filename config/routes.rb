Rails.application.routes.draw do
  class AuthenticationConstraint
    def matches?(request)
      request.env['warden']&.authenticated?(:user)
    end
  end

  devise_for :users

  constraints(AuthenticationConstraint.new) do
    resources :lists do
      resources :items, except: [:destroy]
    end

    resources :friendships
    resources :items, only: [:destroy]

    post '/items/:id/update_status', to: "items#update_status", as: "item_update_status"
    put '/friendships/:id/accept_friendship', to: 'friendships#accept_friendship', as: 'accept_friendship'

    root to: "lists#index", as: :signed_in_root
  end

  root to: "welcome#home", constraint: lambda { |request| !user_signed_in }
end

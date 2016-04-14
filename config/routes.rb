Rails.application.routes.draw do
  resources :chat_messages, except: [:new, :edit]
  resources :chats, except: [:new, :edit]
  resources :apparel_ratings, except: [:new, :edit]
  resources :apparel_tags, except: [:new, :edit]
  resources :apparel_images, except: [:new, :edit]
  resources :apparels, except: [:new, :edit] do
    collection do
      get 'search'
    end
  end
  post 'users/update_image', to: "users#update_image"

  mount_devise_token_auth_for 'User', at: 'auth', controllers: { 
    registrations: 'overrides/registrations', 
    omniauth_callbacks: "overrides/omniauth_callbacks" 
  }
  end

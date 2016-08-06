Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :students do
    collection do
      get 'dashboard'
      get 'import'
      post 'import'
    end
    member do
      post 'update_class'
    end
  end

  resources :messages

  root 'students#dashboard'
end

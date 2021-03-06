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

  resources :messages do
    collection do
      post 'update_status'
    end
  end

  resources :attendances do
    collection do
      get 'show_student'
    end
  end

  root 'students#dashboard'
end

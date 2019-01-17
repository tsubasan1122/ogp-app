Rails.application.routes.draw do
  devise_for :users
  root 'homes#index'
  resources :jobs, only: [:new, :index, :create, :show] do
    resources :entries
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

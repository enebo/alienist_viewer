Rails.application.routes.draw do

  resources :classes
  resources :instances, only: [:show]

  root 'classes#index'

end

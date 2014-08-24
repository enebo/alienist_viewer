Rails.application.routes.draw do

  resources :classes
  resources :instances

  root 'classes#index'

end

Rails.application.routes.draw do
  resources :emergencies, only: [:index, :show, :create, :update]
  resources :responders, only: [:index, :show, :create, :update]
end

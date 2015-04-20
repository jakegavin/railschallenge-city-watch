Rails.application.routes.draw do
  resources :responders, only: [:index, :show, :create, :update]
end

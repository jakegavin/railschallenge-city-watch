Rails.application.routes.draw do
  resources :emergencies, only: [:index, :show, :create, :update]
  resources :responders, only: [:index, :show, :create, :update]

  match '*path', to: 'errors#catch_404', via: :all
end

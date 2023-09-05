Rails.application.routes.draw do
  root to: 'tickets#index'

  resources :tickets, only: %i[index show]

  namespace :api do
    namespace :v1 do
      resource :contact_centers, only: [:create]
    end
  end
end
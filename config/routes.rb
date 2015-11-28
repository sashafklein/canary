Rails.application.routes.draw do
  root 'landings#show'

  resources :omniauths, only: [:destroy] do
    get :back, on: :collection
  end

  resources :users, only: [:edit, :update] do
    resources :rules
  end
  
  get '/auth/:provider/callback', to: 'omniauths#back'
  get '/auth/failure', to: redirect('/')
  post "/signout", to: "omniauths#destroy", as: :signout
end

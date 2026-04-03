Rails.application.routes.draw do
  get    "login",  to: "sessions#new",        as: :login
  post   "login",  to: "sessions#create"
  get    "signup", to: "sessions#new_signup",  as: :signup
  post   "signup", to: "sessions#signup"
  delete "logout", to: "sessions#destroy",     as: :logout

  resources :posts do
    resources :comments, only: [:create, :destroy]
  end
  root "posts#index"
end

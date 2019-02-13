Rails.application.routes.draw do
  root   'static_pages#home'
  get    '/help',                 to: 'static_pages#help'
  get    '/about',                to: 'static_pages#about'
  get    '/contact',              to: 'static_pages#contact'
  get    '/signup',               to: 'users#new'
  get    '/clock_in',             to: 'users#clock_in'
  get    '/clock_out',            to: 'users#clock_out'
  get    '/attendance_edit/:id',  to: 'users#attendance_edit'
  get    '/attendance_save',      to: 'users#attendance_save'
  post   '/attendance_save',      to: 'users#attendance_save'
  patch  '/attendance_save',      to: 'users#attendance_save'
  get    '/besic_info/:id/:from', to: 'users#besic_info'
  get    '/login',                to: 'sessions#new'
  post   '/login',                to: 'sessions#create'
  delete '/logout',               to: 'sessions#destroy'
  
  resources :users do
    member do
      get :following, :followers
    end
  end
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :microposts,          only: [:create, :destroy]
  resources :relationships,       only: [:create, :destroy]
end
Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".
  mount Ckeditor::Engine => '/ckeditor'
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  # devise_for :users, path: 'user'
  devise_for :users, path: 'user', controllers: {registrations: "users/registrations"}
  devise_scope :user do
    post '/admin/is_uid_exist', to: 'users/registrations#is_uid_exist'
  end

  get 'update_captcha', to: 'simple_captcha#update_captcha'

  namespace :frontend, path: '/' do
    root 'home#index'
    resources :posts
    resources :users, path: 'u' do
      # resources :posts
      resources :categories
    end
    get 'site/about', to: 'home#about'
  end

  namespace :admin, path: '/admin' do
    root 'home#index'

    get '/profile', to: 'home#profile'
    post '/update_profile', to: 'home#update_profile'

    resources :posts

    resources :replies

    resources :categories
  end

end

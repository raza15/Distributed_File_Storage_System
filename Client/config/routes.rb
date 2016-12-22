Rails.application.routes.draw do
  resources :gmails
  resources :twitters
  resources :facebooks
  resources :cats
  get 'resumes/index'

  get 'resumes/new'

  get 'resumes/create'

  get 'resumes/destroy'

  resources :upload_file_to_servers
  get 'sessions/new'

  resources :users do
    member do
      get 'face_book'
      get 'twitter'
      get 'stack_overflow'
      get 'g_mail'
      get 'google'
      get 'yahoo'
      get 'github'
      get 'linkedin'
      get 'googleplus'
      get 'location_page'
      get 'bayes_train'
    end
  end

  
  resources :resumes do
    member do
      get 'download_file'
      get 'download_file_semi_join_original'
      get 'download_file_bloom_join'
      get 'parallel_semi_join'
      get 'parallel_bloom_join'
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'

  get '/signup', to: 'users#new'
  root 'sessions#new'
end

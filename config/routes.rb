Rails.application.routes.draw do

  resources :password_resets, only: [:new, :create, :edit, :update]
  resources :account_activations, only: [:edit]
  get 'sessions/new'
  post 'sessions/create'
  delete'sessions/destroy'
	resources :users
	# for root path
	root'static_pages#home'
	# code for static page route as shortname
  get 'active' => 'static_pages#active'
  get 'home' => 'static_pages#home'
  get 'help' => 'static_pages#help'
  get 'about' => 'static_pages#about'
  get 'contact' => 'static_pages#contact'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

Rails.application.routes.draw do
  devise_for :users, :controllers => {
    :registrations => 'users/registrations',
    :sessions => 'users/sessions'
  }
  root "expendables#index"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :expendables do
    collection do
      post 'buy'
    end
  end
end

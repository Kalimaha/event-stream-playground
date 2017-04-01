Rails.application.routes.draw do
  resources :orders

  get 'welcome/index'
  root 'welcome#index'
end

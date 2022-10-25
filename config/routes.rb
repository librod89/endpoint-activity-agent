Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  post :files, to: 'files#create'
  patch :files, to: 'files#update'

  post :process, to: 'processes#start'
end

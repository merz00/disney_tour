Rails.application.routes.draw do
  root 'home#index'

  get '/calc' => 'home#calc'
end

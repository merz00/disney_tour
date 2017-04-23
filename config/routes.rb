Rails.application.routes.draw do
  root 'home#index'

  post '/calc' => 'home#calc'
end

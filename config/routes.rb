Rails.application.routes.draw do
  root "home#index"

  get "/articles", to: "articles#index"

  #get '/oauth2-callback', to: 'oauth#oauth_callback'
  #get '/logout', to: 'oauth#logout'
  #get '/login', to: 'oauth#login'
end


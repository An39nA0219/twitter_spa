Rails.application.routes.draw do
  namespace :user do
    post 'login', to: "auths#create"
  end
end

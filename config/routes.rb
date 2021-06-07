Rails.application.routes.draw do
  namespace :user do
    namespace :me do
      get 'emails/auth'
      get 'emails/update'
    end
  end
  scope module: :user do

    post 'login', to: "auths#create"
    root to: "tweets#index"
    get "tweets", to: "tweets#index"

    get 'tweets/:id', to: "tweets#show"

    scope module: :me do
      get 'mytweets', to: "tweets#index"
      post 'mytweets', to: "tweets#create"
      patch 'mytweets/:id', to: "tweets#update"
      delete 'mytweets/:id', to: "tweets#destroy"

      get 'followings', to: "followings#index"
      get 'followers', to: "followers#index"

      get "favorites", to: "favorites#index"
      post "tweets/:tweet_id/favorites", to: "favorites#create"
      delete "tweets/:tweet_id/favorites", to: "favorites#destroy"

      get 'profiles', to: "profiles#index"
      patch 'profiles', to: "profiles#update"

      post 'emails/auth', to: "emails#auth"
      patch 'emails', to: "emails#update"
    end
  end
end

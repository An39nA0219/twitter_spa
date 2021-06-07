Rails.application.routes.draw do
  scope module: :user do

    post "sign_up", to: "sign_ups#create"
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

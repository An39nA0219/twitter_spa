Rails.application.routes.draw do
  scope module: :user do
    post 'login', to: "auths#create"
    root to: "tweets#index"
    get 'tweets/:id', to: "tweets#show"

    scope module: :me do
      get 'mytweets', to: "tweets#index"
      post 'mytweets', to: "tweets#create"
      patch 'mytweets/:id', to: "tweets#update"
      delete 'mytweets/:id', to: "tweets#destroy"
    end
  end
end

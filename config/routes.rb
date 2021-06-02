Rails.application.routes.draw do
  scope module: :user do
    post 'login', to: "auths#create"
    root to: "timelines#index"

    scope module: :me do
      get 'mytweets', to: "tweets#index"
      post 'mytweets', to: "tweets#create"
      patch 'mytweets/:id', to: "tweets#update"
      delete 'mytweets/:id', to: "tweets#destroy"
    end
  end
end

class User::Me::FavoritesController < ApplicationController
  before_action :require_user_logged_in
  before_action :tweet_is_exist?, only: [:create, :destroy]

  def index
    user = current_user
    favorites = user.favorite_tweets.select("favorite_logs.id as log_id", "tweets.id", "tweets.content", "tweets.created_at")
    favorites = favorites.map{|f| f.attributes}
    favorites.each do |f|
      log = FavoriteLog.find(f["log_id"])
      t_user = User.find(log.user_id)
      f["user_id"] = t_user.id
      f["name"] = t_user.name
    end
    render json: {
      status: "success",
      favorites: favorites
    }
  end

  def create
    user = current_user
    if FavoriteLog.create!(user_id: user.id, tweet_id: params[:tweet_id])
      render json: {
        status: "success"
      }
    else
      render_internal_server_error("failed to add favorite")
    end
  end

  def destroy
    user = current_user
    tweet = Tweet.find(params[:tweet_id])
    log = FavoriteLog.find_by(user_id: user.id, tweet_id: tweet.id)
    if log.present?
      if log.destroy
        render json: {
          status: "success"
        }
      else
        render_internal_server_error("failed to delete favorite")
      end
    else
      render_bad_request("favorite log is not exist")
    end
  end

  private

  def tweet_is_exist?
    tweet = Tweet.find_by(id: params[:tweet_id])
    render_bad_request("no content") if tweet.blank?
  end
end

class User::TimelinesController < ApplicationController

  before_action :require_user_logged_in

  def index
    user = current_user
    ids = user.followings.pluck(:id).push(user.id)
    tweets = Tweet.joins(:user).where(users: {id: ids})
    render json: {
      tweets: tweets
    }
  end
end

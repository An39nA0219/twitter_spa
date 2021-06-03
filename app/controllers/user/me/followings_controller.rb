class User::Me::FollowingsController < ApplicationController
  before_action :require_user_logged_in

  def index
    user = current_user
    followings = user.followings.select("users.id", "users.name")
    render json: {
      followings: followings
    }
  end
end

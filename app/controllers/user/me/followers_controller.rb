class User::Me::FollowersController < ApplicationController
  before_action :require_user_logged_in

  def index
    user = current_user
    followers = user.followers.select("users.id", "users.name")
    render json: {
      status: "success",
      msg: "followers",
      followers: followers
    }
  end
end

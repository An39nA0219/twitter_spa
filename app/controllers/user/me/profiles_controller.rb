class User::Me::ProfilesController < ApplicationController

  before_action :require_user_logged_in

  def index
    user = current_user
    render json:{
      status: "success",
      msg: "your current profile",
      user: {
        name: user.name,
        profile: user.profile,
      },
      status: {
        followings: user.followings.count,
        followers: user.followers.count,
        favorite_tweets: user.favorite_tweets.count
      }
    }
  end

  def update
    user = current_user
    user.attributes = profiles_params
    if user.name
      if user.save!
        render json: {
          status: "success",
          msg: "saved your profile"
        }
      else
        render_internal_server_error("failed to save")
      end
    else
      render_bad_request("name is required")
    end

  end

  private

  def profiles_params
    params.permit(:name, :profile)
  end

end

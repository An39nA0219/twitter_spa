class User::TweetsController < ApplicationController

  before_action :require_user_logged_in

  def index
    user = current_user
    ids = user.followings.pluck(:id).push(user.id)
    tweets = Tweet.joins(:user).where(users: {id: ids})
    render json: {
      status: "success",
      msg: "timeline",
      tweets: tweets
    }
  end

  def show
    user = current_user
    tweet = Tweet.find_by(id: params[:id])
    t_user = tweet.user
    
    if tweet.replies

    if tweet
      render json: {
        status: "success",
        msg: "show a tweet",
        tweet: {
          id: tweet.id,
          content: tweet.content,
          created_at: tweet.created_at
        },
        t_user: {
          id: t_user.id,
          name: t_user.name,
        },
        reply: {

        }
      }
    else
      render_bad_request("no content")
    end    
  end
end

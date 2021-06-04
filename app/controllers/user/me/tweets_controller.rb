class User::Me::TweetsController < ApplicationController
  before_action :require_user_logged_in

  def index
    user = current_user
    tweets = user.tweets.all.order(created_at: "DESC").select(:id, :content, :created_at)
    tweets = tweets.map{|t| t.attributes}
    tweets.each do |t|
      t["created_at"] = t["created_at"].to_s(:default)
    end

    render json: {
      status: "success",
      msg: "my tweets",
      tweets: tweets
    }
  end

  def create
    user = current_user
    tweet = Tweet.new(tweet_params)
    if tweet.content.present?
      tweet.user_id = user.id
      if is_correct_id?(reply_params[:tweet_id])
        if tweet.save!
          original_tweet = Tweet.find_by(id: reply_params[:tweet_id])
          if original_tweet
            if Reply.create!(tweet_id: original_tweet.id, reply_id: tweet.id)
              render json: {
                status: "success",
                msg: "save reply tweet"
              }
            else
              render_internal_server_error("failed to reply")
            end
          else
            render json: {
              status: "success",
              msg: "save tweet"
            }
          end
        else
          render_internal_server_error("failed to save")
        end
      else
        render_bad_request("original tweet is not found")
      end
    else
      render_bad_request("no content")
    end
    
  end

  def update
    user = current_user
    tweet = Tweet.find_by(id: params[:id])

    if tweet && tweet.user_id == user.id
      if tweet_params[:content].present?
        if tweet.update!(tweet_params)
          render json: {
            status: "success",
            msg: "update tweet"
          }
        else
          render_internal_server_error("failed to save")
        end
      else
        render_bad_request("no content")
      end
    else
      render_unauthorized
    end
  end

  def destroy
    user = current_user
    tweet = Tweet.find_by(id: params[:id])

    if tweet && tweet.user_id == user.id
      if tweet.destroy
        render json: {
          status: "success",
          msg: "delete tweet"
        }
      else
        render_internal_server_error("failed to delete")
      end
    else
      render_unauthorized
    end
  end

  private

  def tweet_params
    params.permit(:content)
  end

  def reply_params
    params.permit(:tweet_id)
  end

  def is_correct_id?(params)
    return true if params.blank?
    original_tweet = Tweet.find_by(id: params)
    original_tweet.present?
  end
end

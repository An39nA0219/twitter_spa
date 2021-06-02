class User::AuthsController < ApplicationController

  require "jwt"

  def create
    email = params[:email]
    password = params[:password]
    
    if login(email, password)
      user = User.find_by(email: email)
      token = issue_token(user.id)

      render json: {
        status: "success",
        msg: "login",
        token: token,
      }
    else
      render json:{
        status: "failed",
        msg: "failed to auth"
      }
    end
  end

  private

  def login(email, password)
    user = User.find_by(email: email)
    user && user.authenticate(password)
  end

  def issue_token(user_id)
    # 12時間以内の有効期限を作る
    limit= DateTime.now
    limit += Rational(12, 24)

    # sample data
    payload = {
      user_id: user_id,
      limit: limit.to_i
    }

    secret = Rails.application.credentials[:jwt_pw]

    # payload を暗号化
    token = JWT.encode(payload, secret, 'HS512')
  end
  
end

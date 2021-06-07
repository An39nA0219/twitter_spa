class User::Me::EmailsController < ApplicationController

  require 'date'
  require 'uri'

  before_action :require_user_logged_in

  def auth
    user = current_user
    if filled_all_params?(emails_params)
      if can_auth?(user, emails_params)
        email = emails_params[:email]
        email_confirmation = emails_params[:confirmation]
        if email != email_confirmation
          data ="#{user.id},#{emails_params[:email]},#{limit} "

          code = aes_encrypt_for_email(data)
          url = URI.encode_www_form(code: code)

          if NotificationMailer.change_email(user, url).deliver_now
            render json: {
              status: "success",
              msg: "send a guide email"
            }
          else
            render_internal_server_error("failed to send a email")
          end
        else
          render_bad_request("'email' and 'email confirmation' are must be same")
        end
      else
        render_unauthorized
      end
    else
      render_unauthorized
    end
  end

  def update
    code = code_params[:code]

    # URI形式からの復号
    code = URI.decode_www_form(code).flatten[0]
    # AES復号
    code = aes_decrypt_for_email(code)
    # 文字列をカンマ区切りで分割
    code = code.split(",")
    user_id = code[0]
    email = code[1]
    limit = code[2]

    # limitが期限内かどうかのifを入れる
    now = DateTime.now
    if now < limit
      # 同じメアドの人がいないか
      unless User.find_by(email: email)
        user = User.find(user_id)
        user.email = email

        if user.save!
          render json: {
            status: "success",
            msg: "changed your mail address"
          }
        else
          render_internal_server_error("failed to save")
        end
      else
        render_bad_request("this address can't be used")
      end
    else
      render_unauthorized
    end
  end

  private

  def emails_params
    params.permit(:secret_question, :secret_answer, :password, :email, :email_confirmation)
  end

  def code_params
    params.permit(:code)
  end

  def filled_all_params?(params)
    !params.values.include?(nil)
  end

  def can_auth?(user, params)
    secret_question = params[:secret_question]
    secret_answer = params[:secret_answer]
    password = params[:password]
    if user.secret_question == secret_question && user.secret_answer == secret_answer
      if user.authenticate(password)
        return true
      else
        return false
      end
    else
      return false
    end
  end

  def limit
    now = DateTime.now
    # 30分以内のリミット
    now += Rational(30, 24 * 60)
  end

end

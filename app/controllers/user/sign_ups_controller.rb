class User::SignUpsController < ApplicationController

  def create
    if filled_all_params?(users_params)
      user = User.new(users_params)
      unless User.find_by(email: user.email)
        if user.save! && NotificationMailer.sign_up(user).deliver_now
          render json:{
            status: "success",
            msg: "sign up"
          }
        else
          render_internal_server_error("failed to save")
        end
      else
        render_bad_request("this address can't be used")
      end
    else
      render_bad_request("all params are not filled")
    end
  end

  private

  def users_params
    params.permit(:name, :email, :password, :password_confirmation, :secret_question, :secret_answer)
  end

  def filled_all_params?(params)
    !params.values.include?(nil)
  end
end

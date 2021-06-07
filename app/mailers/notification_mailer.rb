class NotificationMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notification_mailer.change_email.subject
  #

  def sign_up(user)
    @user = user

    mail to: @user.email,
    subject: "【Twitter SPA】アカウントが登録されました"
  end

  def change_email(user, url)
    @user = user
    @url = url

    mail to: @user.email,
    subject: "【Twitter SPA】emailの再設定依頼を承りました"
  end
end

class UserMailer < ApplicationMailer
  def account_activation user
    @user = user
    mail to: user.email, subject: t("mailers.user_mailer.activated")
  end

  def password_reset; end
end

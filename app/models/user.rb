class User < ApplicationRecord
  VALID_EMAIL_REGEX = Settings.user.email.regex

  validates :name, presence: true, length:
    {maximum: Settings.user.name.length}
  validates :email, presence: true, length:
    {maximum: Settings.user.email.length},
    format: {with: VALID_EMAIL_REGEX},
    uniqueness: true
  validates :password, presence: true, length:
    {minimum: Settings.user.password.length}

  has_secure_password

  before_save :downcase_email

  private

  def downcase_email
    email.downcase!
  end
end

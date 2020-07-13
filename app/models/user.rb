class User < ApplicationRecord
  VALID_EMAIL_RAGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  has_secure_password validations: false
  has_many :feeds, dependent: :destroy

  validates :name, presence: true, length: { maximum: 50 }, unless: :uid?
  validates :email, presence: true, length: { maximum: 255 }, uniqueness: { case_sensitive: true }, format: { with: VALID_EMAIL_RAGEX }, unless: :uid?
  validates :password, presence: true, length: { minimum: 6 }, unless: :uid?

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_initialize.tap do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.name = auth.info.name
      user.email = auth.info.email
      user.image = auth.info.image
      user.oauth_token = auth.credentials.token
      user.oauth_expires_at = Time.at(auth.credentials.expires_at)
      return user
    end
  end
end

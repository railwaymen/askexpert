class User < ActiveRecord::Base
  devise :database_authenticatable, :validatable, :omniauthable, omniauth_providers: [:facebook, :linkedin]

  has_many :authentications, dependent: :destroy
  has_many :profiles, dependent: :nullify
  has_many :contacts, through: :profiles
  has_many :posts, dependent: :destroy
end

class User < ActiveRecord::Base
  devise :database_authenticatable, :validatable, :omniauthable, omniauth_providers: [:facebook, :linkedin]

  has_many :authentications
end

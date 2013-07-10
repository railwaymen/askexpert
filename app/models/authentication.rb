class Authentication < ActiveRecord::Base
  belongs_to :user

  validates :provider, :uid, :token, presence: true
  validates :uid, uniqueness: {scope: :provider}
end

class Authentication < ActiveRecord::Base
  belongs_to :user
  has_one :profile, dependent: :nullify

  validates :provider, :uid, :token, presence: true
  validates :uid, uniqueness: {scope: :provider}
end

class Profile < ActiveRecord::Base
  include Indexable
  
  belongs_to :user
  belongs_to :authentication
  has_many :contact_connections, class_name: "ProfileConnection", foreign_key: :following_id, dependent: :destroy
  has_many :contacts, through: :contact_connections, source: :followed

  validates :provider, :uid, :name, presence: true
  validates :uid, uniqueness: {scope: :provider}

  acts_as_taggable
end

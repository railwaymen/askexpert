class Comment < ActiveRecord::Base
  belongs_to :post
  belongs_to :user

  validates :post, :user, :content, presence: true

  scope :helpful, ->{where(helpful: true)}
end

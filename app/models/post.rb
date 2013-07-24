class Post < ActiveRecord::Base
  include Indexable
  
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :shares, dependent: :destroy

  validates :user, :content, presence: true

  acts_as_taggable
end

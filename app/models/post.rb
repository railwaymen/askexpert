class Post < ActiveRecord::Base
  include Indexable
  
  belongs_to :user
  has_many :comments

  validates :user, :content, presence: true

  acts_as_taggable
end

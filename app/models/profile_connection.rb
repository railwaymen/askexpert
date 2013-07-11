class ProfileConnection < ActiveRecord::Base
  belongs_to :following, class_name: "Profile"
  belongs_to :followed, class_name: "Profile"

  validates :following_id, :followed_id, presence: true
  validates :following_id, uniqueness: {scope: :followed_id}
end

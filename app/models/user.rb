class User < ActiveRecord::Base
  devise :database_authenticatable, :validatable, :omniauthable, omniauth_providers: [:facebook, :linkedin]

  has_many :authentications, dependent: :destroy
  has_many :profiles, dependent: :nullify
  has_many :contacts, through: :profiles
  has_many :posts, dependent: :destroy
  has_many :comments
  has_one :public_profile, class_name: "Profile"
  has_many :subscriptions, foreign_key: :subscriber_id, dependent: :destroy
  has_many :subscribed_users, through: :subscriptions, source: :subscribed

  after_create :ensure_public_profile

  searchable do
    text :name, boost: 4.0 do
      public_profile.name
    end
    text :location, boost: 3.0 do
      public_profile.location
    end
    text :tags, boost: 2.0 do
      public_profile.tag_list
    end
    text :posts, boost: 1.0 do
      posts.pluck(:content)
    end
  end

  def can_subscribe?(other)
    self != other && !subscribed_users.include?(other)
  end

  def subscribe(other)
    subscribed_users << other if can_subscribe?(other)
  end

  def connect(other)
    ProfileConnection.create(following: public_profile, followed: other.public_profile)
  end

  def visible_posts
    user_ids = subscribed_user_ids
    user_ids << id
    Post.where(user_id: user_ids).order(created_at: :desc)
  end

  private

  def ensure_public_profile
    create_public_profile!(provider: "ask_expert", uid: id, email: email, name: name)
  end
end

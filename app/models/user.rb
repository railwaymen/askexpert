class User < ActiveRecord::Base
  devise :database_authenticatable, :validatable, :omniauthable, omniauth_providers: [:facebook, :linkedin]

  has_many :authentications, dependent: :destroy
  has_many :profiles, dependent: :nullify
  has_many :contacts, through: :profiles
  has_many :posts, dependent: :destroy
  has_one :public_profile, class_name: "Profile"

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

  private

  def ensure_public_profile
    create_public_profile!(provider: "ask_expert", uid: id, email: email, name: name)
  end
end

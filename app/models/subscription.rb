class Subscription < ActiveRecord::Base
  belongs_to :subscriber, class_name: "User"
  belongs_to :subscribed, class_name: "User"

  validates :subscribed_id, uniqueness: {scope: :subscriber_id}

  after_create :connect_users, if: :reciprocated?

  def reciprocated?
    Subscription.where(subscriber_id: subscribed_id).where(subscribed_id: subscriber_id).any?
  end

  private

  def connect_users
    subscriber.connect(subscribed)
    subscribed.connect(subscriber)
  end
end

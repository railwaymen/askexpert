class Share < ActiveRecord::Base
  belongs_to :sender, class_name: "User"
  belongs_to :recipient, class_name: "Profile"
  belongs_to :post

  validates :sender, :recipient, :post, :content, presence: true
  validates :recipient_id, inclusion: {in: ->(share){share.sender.contact_ids}}, if: "sender.present?", on: :create

  after_create :deliver

  private

  def deliver
    if recipient.email.present?
      Mailer.share(recipient.email, self).deliver
    elsif auth = sender.authentications.find_by(provider: recipient.provider)
      auth.share(self)
    end
  end
end

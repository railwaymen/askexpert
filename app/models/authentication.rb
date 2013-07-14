class Authentication < ActiveRecord::Base
  belongs_to :user
  has_one :profile, dependent: :nullify

  validates :provider, :uid, :token, presence: true
  validates :uid, uniqueness: {scope: :provider}

  after_save :enqueue_retrieving_data, if: ->(auth) do
    auth.user_id_changed? && auth.user_id.present?
  end

  def retrieve_data
    self.profile = service.profile
    profile.user = user
    profile.save
    service.set_contacts
  end

  private

  def service
    @service ||= "#{provider.capitalize}Service".constantize.new(token, secret)
  end

  def enqueue_retrieving_data
    Resque.enqueue(RetrieveDataJob, id)
  end
end

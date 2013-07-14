class RetrieveDataJob
  @queue = :retrieve_data

  def self.perform(authentication_id)
    auth = Authentication.find(authentication_id)
    auth.retrieve_data
  end
end
class LinkedinService
  PROVIDER = "linkedin"
  SCOPES = 'r_basicprofile r_fullprofile r_emailaddress r_network w_messages'
  FIELDS = ["id", "email-address", "formatted-name", "headline", "skills", "location", "interests", "group-memberships"]

  def initialize(auth_token, auth_secret)
    @auth_token = auth_token
    @auth_secret = auth_secret
  end

  def profile
    @profile ||= begin
      service_profile = client.profile(fields: FIELDS)
      app_profile = Profile.find_or_initialize_by(provider: PROVIDER, uid: service_profile.id)
      set_profile(app_profile, service_profile)
    end
  end

  def set_contacts
    service_contacts = client.connections(fields: FIELDS)
    app_contacts = service_contacts.all.map do |service_contact|
      app_profile = Profile.find_or_initialize_by(provider: PROVIDER, uid: service_contact.id)
      contact = set_profile(app_profile, service_contact)
      ProfileConnection.create(following: profile, followed: contact)
    end
  end

  def share(shared_message)
    subject = "AskExpert post"
    host = Rails.application.config.action_mailer.default_url_options[:host]
    url = Rails.application.routes.url_helpers.public_post_url(id: shared_message.post_id, host: host)
    content = <<-eos
    #{shared_message.content}

    Greetings, #{shared_message.sender.name}

    Link to post: #{url}
    eos
    client.send_message(subject, content, [shared_message.recipient.uid])
  end

  private

  def client
    @client ||= LinkedIn::Client.new(OAUTH_CONFIG[:linkedin][:api_key], OAUTH_CONFIG[:linkedin][:secret_key]).tap do |linkedin|
      linkedin.authorize_from_access(@auth_token, @auth_secret)
    end
  end

  def set_profile(app_profile, service_profile)
    app_profile.email    = service_profile.email_address
    app_profile.name     = service_profile.formatted_name
    app_profile.summary  = service_profile.headline
    app_profile.location = object_name(service_profile.location)
    app_profile.tag_list << service_profile.interests
    app_profile.tag_list += tags(:skill, service_profile.skills)
    app_profile.tag_list += tags(:group, service_profile.group_memberships)
    app_profile.save
    app_profile
  end

  def tags(field, collection)
    if collection
      collection.all.map(&field).map(&:name)
    else
      []
    end
  end

  def object_name(obj)
    obj.try(:name)
  end
end
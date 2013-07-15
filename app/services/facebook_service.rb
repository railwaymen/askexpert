class FacebookService
  PROVIDER = "facebook"
  SCOPES = "publish_stream, email, user_about_me, user_location, user_interests, user_activities, user_likes, friends_about_me, friends_location, friends_interests, friends_activities, friends_likes"
  FIELDS = "id, email, name, bio, location, interests, activities, languages"

  def initialize(auth_token, auth_secret)
    @auth_token = auth_token
  end

  def profile
    @profile ||= begin
      service_profile = client.get_object("me", fields: FIELDS)
      app_profile = Profile.find_or_initialize_by(provider: PROVIDER, uid: service_profile["id"])
      set_profile(app_profile, service_profile)
    end
  end

  def set_contacts
    service_contacts = client.get_connections("me", "friends", fields: FIELDS)
    app_contacts = service_contacts.map do |service_contact|
      app_profile = Profile.find_or_initialize_by(provider: PROVIDER, uid: service_contact["id"])
      contact = set_profile(app_profile, service_contact)
      ProfileConnection.create(following: profile, followed: contact)
    end
  end

  private

  def client
    @client ||= Koala::Facebook::API.new(@auth_token)
  end

  def set_profile(app_profile, service_profile)
    app_profile.email    = service_profile["email"]
    app_profile.name     = service_profile["name"]
    app_profile.summary  = service_profile["bio"]
    app_profile.location = object_name(service_profile["location"])
    app_profile.tag_list += tags(service_profile["languages"])
    app_profile.tag_list += tags(service_profile["interests"].try(:[], "data"))
    app_profile.tag_list += tags(service_profile["activities"].try(:[], "data"))
    app_profile.save
    app_profile
  end

  def tags(collection)
    if collection
      collection.map{|obj| obj["name"]}
    else
      []
    end
  end

  def object_name(obj)
    obj ||= {}
    obj["name"]
  end
end
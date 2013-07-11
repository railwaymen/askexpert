require 'resque'
require 'resque/server'

Resque.redis = "localhost:6379"
Resque.redis.namespace = "ask_expert"

Resque::Server.use(Rack::Auth::Basic) do |user, password|
  user == "admin" && password == "admin"
end

Resque.inline = Rails.env.test?
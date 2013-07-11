# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :profile_connection do
    following nil
    followed nil
  end
end

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :profile do
    user nil
    authentication nil
    provider "MyString"
    uid "MyString"
    name "MyString"
    summary "MyText"
    location "MyString"
  end
end

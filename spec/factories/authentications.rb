# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :authentication do
    user nil
    provider "MyString"
    uid "MyString"
    token "MyText"
    secret "MyString"
  end
end

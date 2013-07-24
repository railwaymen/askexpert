# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :share do
    sender nil
    recipient nil
    post nil
    content "MyText"
  end
end

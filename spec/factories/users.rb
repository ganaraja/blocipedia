FactoryGirl.define do
  factory :user do
    email "test_user@example.com"
    password  "password"
    role :standard
  end
end

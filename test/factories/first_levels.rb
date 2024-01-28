FactoryBot.define do
  factory :first_level do
    association :team
    data { "MyString" }
  end
end

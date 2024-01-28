FactoryBot.define do
  factory :second_level do
    association :first_level
    data { "MyString" }
  end
end

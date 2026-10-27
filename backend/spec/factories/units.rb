FactoryBot.define do
  factory :unit do
    association :unit_category

    sequence(:code) { |n| "unit_#{n}" }
    name { "Repetition" }
    symbol { "rep" }
  end
end

FactoryBot.define do
  factory :activity_category do
    sequence(:name) { |n| "Activity Category #{n}" }
  end
end

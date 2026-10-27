FactoryBot.define do
  factory :unit_category do
    sequence(:name) { |n| "Category #{n}" }
  end
end

FactoryBot.define do
  factory :activity_template do
    association :activity_category
    association :unit

    sequence(:name) { |n| "Activity Template #{n}" }
  end
end

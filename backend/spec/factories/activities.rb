FactoryBot.define do
  factory :activity do
    association :activity_category
    association :unit

    sequence(:name) { |n| "Activity #{n}" }

    trait :archived do
      archived_at { Time.current }
    end
  end
end

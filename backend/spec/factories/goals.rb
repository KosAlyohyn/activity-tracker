FactoryBot.define do
  factory :goal do
    association :activity

    period_type { "calendar" }
    period_unit { "day" }
    period_value { 1 }

    trait :rolling do
      period_type { "rolling" }
      period_unit { "hour" }
      period_value { 3 }
    end

    trait :archived do
      archived_at { Time.current }
    end
  end
end

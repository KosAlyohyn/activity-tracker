FactoryBot.define do
  factory :goal_version do
    association :goal

    target_value { 100 }
    effective_from { Time.current }
  end
end

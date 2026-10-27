FactoryBot.define do
  factory :entry do
    association :activity

    value { 10 }
    performed_at { Time.current }
  end
end

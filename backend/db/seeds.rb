repetitions = UnitCategory.find_or_create_by!(name: "Repetitions")

reps = Unit.find_or_create_by!(code: "rep") do |unit|
  unit.name = "Repetition"
  unit.symbol = "rep"
  unit.unit_category = repetitions
end

strength = ActivityCategory.find_or_create_by!(name: "Strength")

[ "Push-ups", "Pull-ups", "Squats" ].each do |name|
  ActivityTemplate.find_or_create_by!(name: name) do |template|
    template.activity_category = strength
    template.unit = reps
  end
end

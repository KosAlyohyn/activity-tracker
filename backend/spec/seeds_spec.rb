require "rails_helper"

# rubocop:disable-next RSpec/DescribeClass
RSpec.describe "Database seeds" do
  describe "database seeds" do
    it "creates predefined activity templates" do
      Rails.application.load_seed

      expect(ActivityTemplate.pluck(:name))
        .to contain_exactly("Push-ups", "Pull-ups", "Squats")
    end

    it "does not duplicate records when executed twice" do
      Rails.application.load_seed

      expect { Rails.application.load_seed }
        .not_to change(ActivityTemplate, :count)
    end

    it "assigns the correct category and unit" do
      Rails.application.load_seed

      template = ActivityTemplate.find_by!(name: "Push-ups")

      expect(template.activity_category.name).to eq("Strength")
      expect(template.unit.code).to eq("rep")
    end
  end
end

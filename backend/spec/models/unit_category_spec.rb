require "rails_helper"

RSpec.describe UnitCategory, type: :model do
  describe "associations" do
    subject(:unit_category) { FactoryBot.create(:unit_category) }

    let(:unit) { FactoryBot.create(:unit, unit_category: unit_category) }

    it "has many units" do
      expect(unit_category.units).to include(unit)
    end
  end

  describe "validations" do
    subject(:unit_category) { FactoryBot.build(:unit_category) }

    it "is valid with valid attributes" do
      expect(unit_category).to be_valid
    end

    context "without a name" do
      let(:unit_category) { FactoryBot.build(:unit_category, name: nil) }

      it "is invalid" do
        expect(unit_category).not_to be_valid
      end
    end

    context "with a duplicate name" do
      let(:existing_category) { FactoryBot.create(:unit_category) }
      let(:unit_category) do
        FactoryBot.build(:unit_category, name: existing_category.name)
      end

      it "is invalid" do
        expect(unit_category).not_to be_valid
      end
    end
  end
end

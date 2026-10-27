require "rails_helper"

RSpec.describe Unit, type: :model do
  describe "associations" do
    subject(:unit) { FactoryBot.build(:unit) }

    it "belongs to a unit category" do
      expect(unit.unit_category).to be_a(UnitCategory)
    end

    context "without a unit category" do
      let(:unit) { FactoryBot.build(:unit, unit_category: nil) }

      it "is invalid" do
        expect(unit).not_to be_valid
      end
    end
  end

  describe "validations" do
    subject(:unit) { FactoryBot.build(:unit) }

    it "is valid with valid attributes" do
      expect(unit).to be_valid
    end

    context "without a code" do
      let(:unit) { FactoryBot.build(:unit, code: nil) }

      it "is invalid" do
        expect(unit).not_to be_valid
      end
    end

    context "without a name" do
      let(:unit) { FactoryBot.build(:unit, name: nil) }

      it "is invalid" do
        expect(unit).not_to be_valid
      end
    end

    context "with a duplicate code" do
      let(:existing_unit) { FactoryBot.create(:unit) }
      let(:unit) { FactoryBot.build(:unit, code: existing_unit.code) }

      it "is invalid" do
        expect(unit).not_to be_valid
      end
    end
  end
end

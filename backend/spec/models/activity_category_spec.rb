require "rails_helper"

RSpec.describe ActivityCategory, type: :model do
  describe "associations" do
    it "has many activities" do
      expect(described_class.reflect_on_association(:activities).macro).to eq(:has_many)
    end
  end

  describe "validations" do
    subject(:activity_category) { FactoryBot.build(:activity_category) }

    it "is valid with valid attributes" do
      expect(activity_category).to be_valid
    end

    context "without a name" do
      let(:activity_category) { FactoryBot.build(:activity_category, name: nil) }

      it "is invalid" do
        expect(activity_category).not_to be_valid
      end
    end

    context "with a duplicate name" do
      let(:existing_category) { FactoryBot.create(:activity_category) }
      let(:activity_category) do
        FactoryBot.build(:activity_category, name: existing_category.name)
      end

      it "is invalid" do
        expect(activity_category).not_to be_valid
      end
    end
  end
end

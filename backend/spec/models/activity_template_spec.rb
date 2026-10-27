require "rails_helper"

RSpec.describe ActivityTemplate, type: :model do
  describe "associations" do
    subject(:activity_template) { FactoryBot.build(:activity_template) }

    it "belongs to an activity category" do
      expect(activity_template.activity_category).to be_a(ActivityCategory)
    end

    it "belongs to a unit" do
      expect(activity_template.unit).to be_a(Unit)
    end
  end

  describe "validations" do
    subject(:activity_template) { FactoryBot.build(:activity_template) }

    it "is valid with valid attributes" do
      expect(activity_template).to be_valid
    end

    context "without a name" do
      let(:activity_template) { FactoryBot.build(:activity_template, name: nil) }

      it "is invalid" do
        expect(activity_template).not_to be_valid
      end
    end

    context "without an activity category" do
      let(:activity_template) do
        FactoryBot.build(:activity_template, activity_category: nil)
      end

      it "is invalid" do
        expect(activity_template).not_to be_valid
      end
    end

    context "without a unit" do
      let(:activity_template) { FactoryBot.build(:activity_template, unit: nil) }

      it "is invalid" do
        expect(activity_template).not_to be_valid
      end
    end

    context "with a duplicate name" do
      let(:existing_template) { FactoryBot.create(:activity_template) }
      let(:activity_template) do
        FactoryBot.build(:activity_template, name: existing_template.name)
      end

      it "is invalid" do
        expect(activity_template).not_to be_valid
      end
    end
  end
end

require "rails_helper"

RSpec.describe GoalVersion, type: :model do
  describe "associations" do
    subject(:goal_version) { FactoryBot.build(:goal_version) }

    it "belongs to a goal" do
      expect(goal_version.goal).to be_a(Goal)
    end
  end

  describe "validations" do
    subject(:goal_version) { FactoryBot.build(:goal_version, **attributes) }

    let(:attributes) { {} }

    it "is valid with valid attributes" do
      expect(goal_version).to be_valid
    end

    context "without a goal" do
      let(:attributes) { { goal: nil } }

      it "is invalid" do
        expect(goal_version).not_to be_valid
      end
    end

    context "without a target value" do
      let(:attributes) { { target_value: nil } }

      it "is invalid" do
        expect(goal_version).not_to be_valid
      end
    end

    context "with a zero target value" do
      let(:attributes) { { target_value: 0 } }

      it "is invalid" do
        expect(goal_version).not_to be_valid
      end
    end

    context "with a negative target value" do
      let(:attributes) { { target_value: -10 } }

      it "is invalid" do
        expect(goal_version).not_to be_valid
      end
    end

    context "with a decimal target value" do
      let(:attributes) { { target_value: 2.5 } }

      it "is valid" do
        expect(goal_version).to be_valid
      end
    end

    context "without effective_from" do
      let(:attributes) { { effective_from: nil } }

      it "is invalid" do
        expect(goal_version).not_to be_valid
      end
    end
  end

  describe "uniqueness" do
    subject(:goal_version) do
      FactoryBot.build(:goal_version, goal: goal, effective_from: effective_from)
    end

    let(:goal) { FactoryBot.create(:goal) }
    let(:effective_from) { Time.current.change(usec: 0) }

    context "when another version has the same effective_from" do
      before do
        FactoryBot.create(:goal_version, goal: goal, effective_from: effective_from)
      end

      it "is invalid" do
        expect(goal_version).not_to be_valid
      end
    end

    context "when another version has a different effective_from" do
      before do
        FactoryBot.create(:goal_version, goal: goal, effective_from: 1.day.ago)
      end

      it "is valid" do
        expect(goal_version).to be_valid
      end
    end

    context "when another goal has the same effective_from" do
      before do
        FactoryBot.create(:goal_version, effective_from: effective_from)
      end

      it "is valid" do
        expect(goal_version).to be_valid
      end
    end
  end

  describe "immutability" do
    subject(:goal_version) do
      FactoryBot.create(:goal_version, effective_from: effective_from)
    end

    context "when the version is already effective" do
      let(:effective_from) { 1.day.ago }

      it "cannot be updated" do
        expect(goal_version.update(target_value: 200)).to be(false)
      end

      it "cannot be destroyed" do
        expect(goal_version.destroy).to be(false)
      end
    end

    context "when the version is scheduled for the future" do
      let(:effective_from) { 1.day.from_now }

      it "can be updated" do
        expect(goal_version.update(target_value: 200)).to be(true)
      end

      it "can be destroyed" do
        expect(goal_version.destroy).to be_truthy
      end
    end
  end
end

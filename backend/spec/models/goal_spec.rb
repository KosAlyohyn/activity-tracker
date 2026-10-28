require "rails_helper"

RSpec.describe Goal, type: :model do
  describe "associations" do
    subject(:goal) { FactoryBot.build(:goal) }

    it "belongs to an activity" do
      expect(goal.activity).to be_a(Activity)
    end
  end

  describe "validations" do
    subject(:goal) { FactoryBot.build(:goal, **attributes) }

    let(:attributes) { {} }

    it "is valid with valid attributes" do
      expect(goal).to be_valid
    end

    context "without an activity" do
      let(:attributes) { { activity: nil } }

      it "is invalid" do
        expect(goal).not_to be_valid
      end
    end

    context "with an invalid period type" do
      let(:attributes) { { period_type: "unknown" } }

      it "is invalid" do
        expect(goal).not_to be_valid
      end
    end

    context "with an invalid period unit" do
      let(:attributes) { { period_unit: "unknown" } }

      it "is invalid" do
        expect(goal).not_to be_valid
      end
    end

    context "with a zero period value" do
      let(:attributes) { { period_value: 0 } }

      it "is invalid" do
        expect(goal).not_to be_valid
      end
    end

    context "with a negative period value" do
      let(:attributes) { { period_value: -1 } }

      it "is invalid" do
        expect(goal).not_to be_valid
      end
    end

    context "with a fractional period value" do
      let(:attributes) { { period_value: 1.5 } }

      it "is invalid" do
        expect(goal).not_to be_valid
      end
    end

    context "with a rolling period" do
      subject(:goal) { FactoryBot.build(:goal, :rolling) }

      it "is valid" do
        expect(goal).to be_valid
      end
    end
  end

  describe "uniqueness" do
    subject(:goal) do
      FactoryBot.build(:goal, activity: activity, **attributes)
    end

    let(:activity) { FactoryBot.create(:activity) }
    let(:attributes) { {} }

    context "when an active goal has the same period" do
      before do
        FactoryBot.create(:goal, activity: activity)
      end

      it "is invalid" do
        expect(goal).not_to be_valid
      end
    end

    context "when an active goal has a different period" do
      before do
        FactoryBot.create(:goal, activity: activity)
      end

      let(:attributes) { { period_unit: "week" } }

      it "is valid" do
        expect(goal).to be_valid
      end
    end

    context "when the existing goal is archived" do
      before do
        FactoryBot.create(:goal, :archived, activity: activity)
      end

      it "is valid" do
        expect(goal).to be_valid
      end
    end
  end

  describe "scopes" do
    let!(:active_goal) { FactoryBot.create(:goal) }
    let!(:archived_goal) { FactoryBot.create(:goal, :archived) }

    describe ".active" do
      it "returns only active goals" do
        expect(described_class.active).to contain_exactly(active_goal)
      end
    end

    describe ".archived" do
      it "returns only archived goals" do
        expect(described_class.archived).to contain_exactly(archived_goal)
      end
    end
  end

  describe "#archived?" do
    subject(:goal) { FactoryBot.build(:goal, **attributes) }

    let(:attributes) { {} }

    context "when the goal is active" do
      it "returns false" do
        expect(goal.archived?).to be(false)
      end
    end

    context "when the goal is archived" do
      let(:attributes) { { archived_at: Time.current } }

      it "returns true" do
        expect(goal.archived?).to be(true)
      end
    end
  end
end

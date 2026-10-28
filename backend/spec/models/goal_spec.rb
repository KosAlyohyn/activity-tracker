require "rails_helper"
include ActiveSupport::Testing::TimeHelpers

RSpec.describe Goal, type: :model do
  describe "associations" do
    subject(:goal) { FactoryBot.build(:goal) }

    it "belongs to an activity" do
      expect(goal.activity).to be_a(Activity)
    end

    it "has many goal versions" do
      expect(described_class.reflect_on_association(:goal_versions).macro).to eq(:has_many)
    end

    it "restricts deletion when goal versions exist" do
      expect(described_class.reflect_on_association(:goal_versions).options[:dependent])
        .to eq(:restrict_with_exception)
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

  describe "#version_at" do
    subject(:version_at) { goal.version_at(time) }

    let(:goal) { FactoryBot.create(:goal) }

    let!(:first_version) do
      FactoryBot.create(:goal_version, goal: goal, target_value: 100, effective_from: 10.days.ago)
    end

    let!(:second_version) do
      FactoryBot.create(:goal_version, goal: goal, target_value: 150, effective_from: 5.days.ago)
    end

    let!(:future_version) do
      FactoryBot.create(:goal_version, goal: goal, target_value: 200, effective_from: 5.days.from_now)
    end

    context "when a version is effective" do
      let(:time) { Time.current }

      it "returns the latest effective version" do
        expect(version_at).to eq(second_version)
      end
    end

    context "when the requested time precedes all versions" do
      let(:time) { 20.days.ago }

      it "returns nil" do
        expect(version_at).to be_nil
      end
    end

    context "when the requested time matches effective_from" do
      let(:time) { first_version.effective_from }

      it "includes the version starting at that time" do
        expect(version_at).to eq(first_version)
      end
    end

    context "when all versions have become effective" do
      let(:time) { 10.days.from_now }

      it "returns the newest version" do
        expect(version_at).to eq(future_version)
      end
    end
  end

  describe "#current_version" do
    subject(:current_version) { goal.current_version }

    let(:goal) { FactoryBot.create(:goal) }

    context "when an effective version exists" do
      let!(:effective_version) do
        FactoryBot.create(:goal_version, goal: goal, effective_from: 1.day.ago)
      end

      before do
        FactoryBot.create(:goal_version, goal: goal, effective_from: 1.day.from_now)
      end

      it "returns the latest effective version" do
        expect(current_version).to eq(effective_version)
      end
    end

    context "when all versions are scheduled for the future" do
      before do
        FactoryBot.create(:goal_version, goal: goal, effective_from: 1.day.from_now)
      end

      it "returns nil" do
        expect(current_version).to be_nil
      end
    end

    context "when the goal has no versions" do
      it "returns nil" do
        expect(current_version).to be_nil
      end
    end
  end

  describe "#next_version" do
    subject(:next_version) { goal.next_version }

    let(:goal) { FactoryBot.create(:goal) }

    context "when future versions exist" do
      let!(:nearest_version) do
        FactoryBot.create(:goal_version, goal: goal, effective_from: 1.day.from_now)
      end

      before do
        FactoryBot.create(:goal_version, goal: goal, effective_from: 3.days.from_now)
        FactoryBot.create(:goal_version, goal: goal, effective_from: 1.day.ago)
      end

      it "returns the nearest future version" do
        expect(next_version).to eq(nearest_version)
      end
    end

    context "when no future versions exist" do
      before do
        FactoryBot.create(:goal_version, goal: goal, effective_from: 1.day.ago)
      end

      it "returns nil" do
        expect(next_version).to be_nil
      end
    end

    context "when the goal has no versions" do
      it "returns nil" do
        expect(next_version).to be_nil
      end
    end
  end

  describe "#replace_next_version!" do
    subject(:replace_version) do
      goal.replace_next_version!(target_value: target_value)
    end

    let(:goal) { FactoryBot.create(:goal) }
    let(:target_value) { 250 }

    context "when a future version exists" do
      let!(:future_version) do
        FactoryBot.create(
          :goal_version,
          goal: goal,
          target_value: 200,
          effective_from: 1.day.from_now
        )
      end

      it "updates the target value" do
        expect { replace_version }
          .to change { future_version.reload.target_value }
          .from(200).to(250)
      end

      it "returns the updated version" do
        expect(replace_version).to eq(future_version)
      end
    end

    context "when no future version exists" do
      before do
        FactoryBot.create(
          :goal_version,
          goal: goal,
          effective_from: 1.day.ago
        )
      end

      it "raises an exception" do
        expect { replace_version }
          .to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context "when the new target value is invalid" do
      let(:target_value) { 0 }

      before do
        FactoryBot.create(
          :goal_version,
          goal: goal,
          effective_from: 1.day.from_now
        )
      end

      it "raises a validation error" do
        expect { replace_version }
          .to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context "when an effective version already exists" do
      let!(:current_version) do
        FactoryBot.create(
          :goal_version,
          goal: goal,
          target_value: 150,
          effective_from: 1.day.ago
        )
      end

      before do
        FactoryBot.create(
          :goal_version,
          goal: goal,
          target_value: 200,
          effective_from: 1.day.from_now
        )
      end

      it "does not modify the effective version" do
        expect { replace_version }
          .not_to change { current_version.reload.attributes }
      end
    end

    context "when multiple future versions exist" do
      let!(:nearest_version) do
        FactoryBot.create(
          :goal_version,
          goal: goal,
          target_value: 200,
          effective_from: 1.day.from_now
        )
      end

      let!(:later_version) do
        FactoryBot.create(
          :goal_version,
          goal: goal,
          target_value: 300,
          effective_from: 3.days.from_now
        )
      end

      it "updates the nearest future version" do
        expect { replace_version }
          .to change { nearest_version.reload.target_value }
          .from(200).to(250)
      end

      it "does not modify the later future version" do
        expect { replace_version }
          .not_to change { later_version.reload.attributes }
      end
    end
  end

  describe "#schedule_version!" do
    subject(:schedule_version) do
      goal.schedule_version!(
        target_value: target_value,
        effective_from: effective_from
      )
    end

    before do
      travel_to(Time.zone.parse('2026-11-01'))
    end

    after do
      travel_back
    end

    let(:goal) { FactoryBot.create(:goal) }
    let(:target_value) { 150 }
    let(:effective_from) { 1.day.from_now }

    context "with valid attributes" do
      it "creates a new goal version" do
        expect { schedule_version }
          .to change(goal.goal_versions, :count).by(1)
      end

      it "assigns the correct attributes" do
        version = schedule_version

        expect(version.target_value).to eq(150)
        expect(version.effective_from).to eq(effective_from)
      end

      it "returns the created version" do
        expect(schedule_version).to be_a(GoalVersion)
      end
    end

    context "with an invalid target value" do
      let(:target_value) { 0 }

      it "raises a validation error" do
        expect { schedule_version }
          .to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context "when effective_from is already taken" do
      before do
        FactoryBot.create(
          :goal_version,
          goal: goal,
          effective_from: effective_from
        )
      end

      it "raises a validation error" do
        expect { schedule_version }
          .to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end

  describe "deletion" do
    subject(:destroy_goal) { goal.destroy! }

    let!(:goal) { FactoryBot.create(:goal) }

    context "when the goal has versions" do
      before do
        FactoryBot.create(:goal_version, goal: goal)
      end

      it "raises an exception" do
        expect { destroy_goal }
          .to raise_error(ActiveRecord::DeleteRestrictionError)
      end
    end

    context "when the goal has no versions" do
      it "deletes the goal" do
        expect { destroy_goal }.to change(described_class, :count).by(-1)
      end
    end
  end
end

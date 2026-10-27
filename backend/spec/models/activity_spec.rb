require "rails_helper"

RSpec.describe Activity, type: :model do
  describe "associations" do
    subject(:activity) { FactoryBot.build(:activity) }

    it "belongs to an activity category" do
      expect(activity.activity_category).to be_a(ActivityCategory)
    end

    it "belongs to a unit" do
      expect(activity.unit).to be_a(Unit)
    end

    it "has many entries" do
      expect(described_class.reflect_on_association(:entries).macro).to eq(:has_many)
    end

    it "restricts deletion when entries exist" do
      expect(described_class.reflect_on_association(:entries).options[:dependent])
        .to eq(:restrict_with_exception)
    end
  end

  describe "validations" do
    subject(:activity) { FactoryBot.build(:activity) }

    it "is valid with valid attributes" do
      expect(activity).to be_valid
    end

    context "without a name" do
      let(:activity) { FactoryBot.build(:activity, name: nil) }

      it "is invalid" do
        expect(activity).not_to be_valid
      end
    end

    context "without an activity category" do
      let(:activity) { FactoryBot.build(:activity, activity_category: nil) }

      it "is invalid" do
        expect(activity).not_to be_valid
      end
    end

    context "without a unit" do
      let(:activity) { FactoryBot.build(:activity, unit: nil) }

      it "is invalid" do
        expect(activity).not_to be_valid
      end
    end

    context "with a duplicate active name" do
      let(:existing_activity) { FactoryBot.create(:activity) }
      let(:activity) { FactoryBot.build(:activity, name: existing_activity.name) }

      it "is invalid" do
        expect(activity).not_to be_valid
      end
    end

    context "when an activity with the same name is archived" do
      let(:existing_activity) { FactoryBot.create(:activity, :archived) }
      let(:activity) { FactoryBot.build(:activity, name: existing_activity.name) }

      it "is valid" do
        expect(activity).to be_valid
      end
    end

    context "when both activities are archived" do
      let(:existing_activity) { FactoryBot.create(:activity, :archived) }
      let(:activity) do
        FactoryBot.build(:activity, :archived, name: existing_activity.name)
      end

      it "is valid" do
        expect(activity).to be_valid
      end
    end
  end

  describe "scopes" do
    let!(:active_activity) { FactoryBot.create(:activity) }
    let!(:archived_activity) { FactoryBot.create(:activity, :archived) }

    describe ".active" do
      it "returns only active activities" do
        expect(described_class.active).to contain_exactly(active_activity)
      end
    end

    describe ".archived" do
      it "returns only archived activities" do
        expect(described_class.archived).to contain_exactly(archived_activity)
      end
    end
  end

  describe "#archive!" do
    subject(:activity) { FactoryBot.create(:activity) }

    it "sets archived_at" do
      expect { activity.archive! }
        .to change(activity, :archived_at).from(nil)
    end
  end

  describe "#restore!" do
    subject(:activity) { FactoryBot.create(:activity, :archived) }

    it "clears archived_at" do
      expect { activity.restore! }
        .to change(activity, :archived_at).to(nil)
    end

    context "when an active activity has the same name" do
      let(:existing_activity) do
        FactoryBot.create(:activity, name: activity.name)
      end

      it "raises a validation error" do
        existing_activity

        expect { activity.restore! }
          .to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end

  describe "#archived?" do
    subject(:activity) { FactoryBot.build(:activity) }

    it "returns false for an active activity" do
      expect(activity).not_to be_archived
    end

    context "when activity is archived" do
      let(:activity) { FactoryBot.build(:activity, :archived) }

      it "returns true" do
        expect(activity).to be_archived
      end
    end
  end

  describe "deletion" do
    subject(:destroy_activity) { activity.destroy! }

    let!(:activity) { FactoryBot.create(:activity) }

    context "when the activity has entries" do
      before do
        FactoryBot.create(:entry, activity: activity)
      end

      it "raises an exception" do
        expect { destroy_activity }
          .to raise_error(ActiveRecord::DeleteRestrictionError)
      end
    end

    context "when the activity has no entries" do
      it "deletes the activity" do
        expect { destroy_activity }.to change(described_class, :count).by(-1)
      end
    end
  end
end

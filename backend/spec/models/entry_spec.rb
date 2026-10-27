require "rails_helper"

RSpec.describe Entry, type: :model do
  describe "associations" do
    subject(:entry) { FactoryBot.build(:entry) }

    it "belongs to an activity" do
      expect(entry.activity).to be_a(Activity)
    end
  end

  describe "validations" do
    subject(:entry) { FactoryBot.build(:entry, **attributes) }

    let(:attributes) { {} }

    it "is valid with valid attributes" do
      expect(entry).to be_valid
    end

    context "without an activity" do
      let(:attributes) { { activity: nil } }

      it "is invalid" do
        expect(entry).not_to be_valid
      end
    end

    context "without a value" do
      let(:attributes) { { value: nil } }

      it "is invalid" do
        expect(entry).not_to be_valid
      end
    end

    context "with a zero value" do
      let(:attributes) { { value: 0 } }

      it "is invalid" do
        expect(entry).not_to be_valid
      end
    end

    context "with a negative value" do
      let(:attributes) { { value: -10 } }

      it "is invalid" do
        expect(entry).not_to be_valid
      end
    end

    context "with a decimal value" do
      let(:attributes) { { value: 2.5 } }

      it "is valid" do
        expect(entry).to be_valid
      end
    end

    context "without performed_at" do
      let(:attributes) { { performed_at: nil } }

      it "is invalid" do
        expect(entry).not_to be_valid
      end
    end
  end

  describe "database constraints" do
    subject(:update_value) { entry.update_columns(value: value) }

    let!(:entry) { FactoryBot.create(:entry) }

    context "when value is zero" do
      let(:value) { 0 }

      it "rejects the update" do
        expect { update_value }
          .to raise_error(ActiveRecord::StatementInvalid)
      end
    end

    context "when value is negative" do
      let(:value) { -10 }

      it "rejects the update" do
        expect { update_value }
          .to raise_error(ActiveRecord::StatementInvalid)
      end
    end
  end
end

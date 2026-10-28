class GoalVersion < ApplicationRecord
  belongs_to :goal

  validates :target_value, presence: true,
                           numericality: { greater_than: 0 }

  validates :effective_from, presence: true,
                             uniqueness: { scope: :goal_id }

  before_update :prevent_changes_to_effective_version
  before_destroy :prevent_changes_to_effective_version

  private

  def prevent_changes_to_effective_version
    return if effective_from_in_database > Time.current

    errors.add(:base, "Effective goal versions cannot be modified")
    throw :abort
  end
end

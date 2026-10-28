class GoalVersion < ApplicationRecord
  belongs_to :goal

  validates :target_value, presence: true,
                           numericality: { greater_than: 0 }

  validates :effective_from, presence: true,
                             uniqueness: { scope: :goal_id }
end

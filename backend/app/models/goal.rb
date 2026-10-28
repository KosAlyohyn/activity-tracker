class Goal < ApplicationRecord
  PERIOD_TYPES = %w[calendar rolling].freeze
  PERIOD_UNITS = %w[hour day week month year].freeze

  belongs_to :activity

  scope :active, -> { where(archived_at: nil) }
  scope :archived, -> { where.not(archived_at: nil) }

  validates :period_type, presence: true, inclusion: { in: PERIOD_TYPES }
  validates :period_unit, presence: true, inclusion: { in: PERIOD_UNITS }
  validates :period_value, numericality: { only_integer: true, greater_than: 0 }

  validates :activity_id,
            uniqueness: {
              scope: %i[period_type period_unit period_value],
              conditions: -> { active }
            },
            if: -> { archived_at.nil? }

  def archived?
    archived_at.present?
  end
end

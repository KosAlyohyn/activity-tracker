class Goal < ApplicationRecord
  PERIOD_TYPES = %w[calendar rolling].freeze
  PERIOD_UNITS = %w[hour day week month year].freeze

  belongs_to :activity

  has_many :goal_versions, dependent: :restrict_with_exception

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

  def version_at(time)
    goal_versions
      .where(effective_from: ..time)
      .order(effective_from: :desc)
      .first
  end

  def current_version
    version_at(Time.current)
  end

  def next_version
    goal_versions
      .where("effective_from > ?", Time.current)
      .order(:effective_from)
      .first
  end

  def replace_next_version!(target_value:)
    version = next_version

    raise ActiveRecord::RecordNotFound, "No scheduled goal version found" unless version

    version.update!(target_value: target_value)
    version
  end

  def schedule_version!(target_value:, effective_from:)
    goal_versions.create!(
      target_value: target_value,
      effective_from: effective_from
    )
  end
end

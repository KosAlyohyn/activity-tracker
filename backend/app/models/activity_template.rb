class ActivityTemplate < ApplicationRecord
  belongs_to :activity_category
  belongs_to :unit

  validates :name, presence: true, uniqueness: true
end

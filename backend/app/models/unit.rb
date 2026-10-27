class Unit < ApplicationRecord
  belongs_to :unit_category

  validates :code, presence: true, uniqueness: true
  validates :name, presence: true
end

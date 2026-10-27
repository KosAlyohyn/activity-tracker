class UnitCategory < ApplicationRecord
  has_many :units, dependent: :restrict_with_exception

  validates :name, presence: true, uniqueness: true
end

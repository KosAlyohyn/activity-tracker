class Entry < ApplicationRecord
  belongs_to :activity

  validates :value, presence: true, numericality: { greater_than: 0 }

  validates :performed_at, presence: true
end

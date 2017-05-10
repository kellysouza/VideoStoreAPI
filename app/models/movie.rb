class Movie < ApplicationRecord

  validates :title, presence: true
  validates :inventory, presence: true, numericality: { only_integer: true }
  validates :release_date, presence: true

  has_many :rentals


end

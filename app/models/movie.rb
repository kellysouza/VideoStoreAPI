class Movie < ApplicationRecord

  validates :title, presence: true
  validates :inventory, presence: true, numericality: { only_integer: true }


end

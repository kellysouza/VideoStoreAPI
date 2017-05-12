class Movie < ApplicationRecord

  validates :title, presence: true
  validates :inventory, presence: true, numericality: { only_integer: true }
  validates :release_date, presence: true

  has_many :rentals



  def find_available_inventory
    self.available_inventory = self.inventory - self.rentals.count
    self.save
  end


end

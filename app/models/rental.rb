class Rental < ApplicationRecord
  belongs_to :movie
  belongs_to :customer

  def find_overdue


  end

end

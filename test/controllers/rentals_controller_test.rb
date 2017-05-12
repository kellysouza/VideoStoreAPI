require "test_helper"

describe RentalsController do
  RENT_KEYS = %w(customer_id movie_id due_date)

  describe "checkout_movie" do

    it "creates a new rental with valid data" do
      proc {
        post checkout_path(movies(:one).title), params: { customer_id: (customers(:one).id)
        }
      }.must_change 'Rental.count', 1
      must_respond_with :ok
    end

    it "won't create a new rental with missing data" do
      proc {
        post checkout_path(movies(:one).title), params: { customer_id: nil}
      }.wont_change 'Rental.count'
      must_respond_with :bad_request
    end

    it "will checkout a title" do skip
      proc { }
    end
  end
end

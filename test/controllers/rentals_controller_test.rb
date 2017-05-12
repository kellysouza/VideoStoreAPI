require "test_helper"

describe RentalsController do
  KEYS = %w(customer_id movie_id due_date)

  describe "create" do
    let(:rental_data) {
      {
        customer_id: 1,
        movie_id: (movies(:one)).id,
        due_date: "20170609",
        title: "time"
      }
    }
    
    it "creates a new rental with valid data" do
      proc {
        post checkout_path("title"), params: { rental: rental_data }
      }.must_change 'Rental.count', 1
      must_respond_with :ok
    end

    it "won't create a new rental with missing data" do
      proc {
      post checkout_path("title"), params: { rental: rental_data }
    }.wont_change 'Rental.count'
    must_respond_with :bad_request
  end
end
end

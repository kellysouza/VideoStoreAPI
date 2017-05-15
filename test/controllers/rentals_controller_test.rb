require "test_helper"

describe RentalsController do
  RENT_KEYS = %w(customer_id movie_id due_date)

  describe "checkout_movie" do

    it "creates a new rental with valid data" do
      proc {
        post checkout_path(movies(:one).title), params: { customer_id: (customers(:one).id), due_date: "20170918"

        }
      }.must_change 'Rental.count', 1
      must_respond_with :ok

    end

    it "won't create a new rental with missing customer" do
      proc {
        post checkout_path(movies(:one).title), params: { customer_id: nil}
      }.wont_change 'Rental.count'
      must_respond_with :bad_request

      body = JSON.parse(response.body)
      body.must_equal "errors"=>{"customer"=>["must exist"], "due_date"=>["can't be blank"] }
    end

    it "won't create a new rental with missing title" do
      proc {
        post checkout_path("title"), params: { customer_id: customers(:one).id }
      }.wont_change 'Rental.count'
      must_respond_with :bad_request

      body = JSON.parse(response.body)
      body.must_equal "errors" => "Movie not found"
    end

    it "won't checkout movie if due date is blank " do
      post checkout_path(movies(:one).title), params: { customer_id: (customers(:one).id)
      }

      proc {
        post checkout_path(movies(:one).title), params: { customer_id: (customers(:one).id)
        }
      }.wont_change 'Rental.count'
      must_respond_with :bad_request

      body = JSON.parse(response.body)
      body.must_equal "errors"=>{"due_date"=>["can't be blank"] }
    end

    it "increases customer  movies_checked_out_count when a rental occurs" do
      customer = customers(:one).id
      customer.movies_checked_out_count

      post checkout_path(movies(:one).title), params: { customer_id: (customers(:one).id)
      }
      customer.movies_checked_out_count

    end

    it "decreases movie.available_inventory when rental occurs" do

    end
  end

  describe "checkin_movie" do

    it "returns a rental with valid data" do
      post checkout_path(movies(:one).title), params: { customer_id: (customers(:one).id)
      }

      proc {
        delete checkin_path(movies(:one).title), params: { customer_id: (customers(:one).id)
        }
      }.must_change 'Rental.count', -1
      must_respond_with :ok
    end

    it "won't return a rental if not checked out title" do

      proc {
        delete checkin_path(movies(:one).title), params: { customer_id: (customers(:one).id)
        }
      }.wont_change 'Rental.count'
      must_respond_with :bad_request

      body = JSON.parse(response.body)
      body.must_equal "errors" => "Rental not found"
    end
  end

end

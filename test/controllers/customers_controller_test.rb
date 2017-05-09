require "test_helper"

describe CustomersController do

  CUST_KEYS = %w(name address city state postal_code phone registered_at account_credit).sort

  describe "index" do
    it "is a real working route" do
      get customers_url
      must_respond_with :success
    end
  end

  it 'returns json' do
    get customers_url
    response.header["Content-Type"].must_include 'json'
  end

  it "returns an array" do
    get customers_url

    body = JSON.parse(response.body)
    body.must_be_kind_of Array
  end

  it "returns all the customers" do
    get customers_url

    body = JSON.parse(response.body)
    body.length.must_equal Customer.count
  end

  it "returns customer with the required fields" do
    get customers_url
    body = JSON.parse(response.body)

    body.each do |customer|
      customer.keys.sort.must_equal CUST_KEYS
    end
  end

  describe "Create" do
    let(:customer_data) {
      { name: "Jack",
        address: "1234 Ada Avenue",
        city: "Seattle",
        state: "Washington",
        postal_code: "98100",
        phone: "6517234456",
        registered_at: "2017",
        account_credit: 10
      }
    }

    it "Can create a customer" do
      proc {
        post customers_url, params: { customer: customer_data }
      }.must_change 'Customer.count', 1
      must_respond_with :ok
      
    end
  end
end

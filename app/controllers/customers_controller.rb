class CustomersController < ApplicationController

  def index
    customers = Customer.all
    render json: customers.as_json(only: [:name, :address, :city, :state, :postal_code, :phone, :registered_at, :account_credit])
  end
end

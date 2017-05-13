require 'rental'

class RentalsController < ApplicationController

  def checkout_movie
    movie =  Movie.where(title: params[:title]).first
    customer =  Customer.find_by(id: params[:customer_id])
    if movie
      mov_id = movie.id
      rental = Rental.new(movie_id: mov_id, customer_id: params[:customer_id], due_date: params[:due_date])
      # debugger
      if movie.available_inventory > 0
        if rental.save
          adjust_inventory_out(movie, customer)
          render status: :ok, json: { id: rental.id}
        else
          render status: :bad_request, json: { errors: rental.errors.messages}
        end
      else
        render status: :bad_request, json: { errors: ["Out of Stock"]}
      end
    else
      render status: :bad_request, json: { errors: ["Movie not found"]}
    end
  end

  def checkin_movie
    movie = Movie.where(title: params[:title]).first
    customer = Customer.find_by(id: params[:customer_id])
    if !movie || !customer
      render status: :bad_request, json:
      if !movie && !customer
        { errors:
          {
            movie: ["not found"],
            customer: ["not found"]
          }
        }
      elsif !customer
        { errors:
          {
            customer: ["not found"]
          }
        }
      else
        { errors:
          {
            movie: ["not found"]
          }
        }
      end
    else
      rental = Rental.find_by(movie_id: movie.id, customer_id: params[:customer_id], checkin_date: nil)
      if !rental
        render status: :bad_request, json: { errors: { rental: ["not found"]}}
      else
        rental.checkin_date = Time.now
        if rental.save
          adjust_inventory_in(movie, customer)
          render status: :ok, json: { customer_id: params[:customer_id], checkin_date: rental.checkin_date}
        end
      end
    end
  end

  def find_overdue
    rentals = Rental.all
    overdue = []
    if rentals.length > 0
      rentals.each do |rental|
        if !rental.checkin_date
          due = Date.parse (rental.due_date)
          if due.past?
            overdue << rental
          end
        end
      end
      render json: overdue.as_json(only: [:movie_id, :customer_id, :due_date, :checkin_date]), status: :ok
    else
      render json: { nothing: true }, status: :not_found
    end
  end



  private

  def adjust_inventory_in(movie, customer)
    movie.available_inventory += 1
    movie.save
    customer.movies_checked_out_count -= 1
    customer.save
  end

  def adjust_inventory_out(movie, customer)
    movie.available_inventory -= 1
    movie.save
    customer.movies_checked_out_count += 1
    customer.save
  end


  def rental_params
    params.permit(:customer_id, :due_date, :title)

  end

end

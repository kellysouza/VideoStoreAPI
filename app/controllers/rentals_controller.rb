require 'rental'

class RentalsController < ApplicationController

  def checkout_movie
    movie =  Movie.where(title: params[:title]).first
    @customer =  Customer.find_by(id: params[:customer_id])
    

    if movie
      mov_id = movie.id
      rental = Rental.new(movie_id: mov_id, customer_id: params[:customer_id], due_date: params[:due_date])
      # debugger
      if movie.available_inventory == nil
        movie.available_inventory = movie.inventory
        # debugger
      end

      if movie.available_inventory > 0
        if rental.save
          movie.available_inventory -= 1
          @customer.movies_checked_out_count += 1
          render status: :ok, json: { id: rental.id}
          #update_avail_inventory
        else
          render status: :bad_request, json: { errors: rental.errors.messages}
        end
      else
        render status: :bad_request, json: { errors: "Out of Stock"}
      end
    else
      render status: :bad_request, json: { errors: "Movie not found"}
    end
  end

  def checkin_movie
    mov_id = Movie.where(title: params[:title]).first.id
    rental = Rental.where(movie_id: mov_id, customer_id: params[:customer_id])
    if rental.length > 0
      if rental.first.delete
        render status: :ok, json: { customer_id: params[:customer_id]}
      else
        render status: :bad_request, json: { errors: "Unable to delete" }
      end
    else
      render status: :bad_request, json: { errors: "Rental not found" }
    end
  end

  def find_overdue
    rentals = Rental.all
    overdue = []
    if rentals.length > 0
      rentals.each do |rental|
        due = Date.parse (rental.due_date)
        if due.past?
          overdue << rental
        end
      end
      render json: overdue.as_json(only: [:movie_id, :customer_id, :due_date]), status: :ok
    else
      render json: { nothing: true }, status: :not_found
    end
  end


  private

  def rental_params
    params.permit(:customer_id, :due_date, :title)

  end

end

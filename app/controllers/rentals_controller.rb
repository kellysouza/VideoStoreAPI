require 'rental'

class RentalsController < ApplicationController

  def checkout_movie
    movie =  Movie.where(title: params[:title]).first
    mov_id = movie.id
    rental = Rental.new(movie_id: mov_id, customer_id: params[:customer_id], due_date: params[:due_date])
    # debugger
    movie.find_available_inventory
    if movie.available_inventory > 0
      if rental.save
        render status: :ok, json: { id: rental.id}
        #update_avail_inventory
      else
        render status: :bad_request, json: { errors: rental.errors.messages}
      end
    else
      render status: :bad_request, json: { errors: "Out of Stock"}
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



  private

  def rental_params
    params.permit(:customer_id, :due_date, :title)

  end

end

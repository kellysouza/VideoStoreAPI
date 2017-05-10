class RentalsController < ApplicationController

  
  def checkout_movie
    mov_id = Movie.where(title: params[:title]).first.id
    rental = Rental.new(movie_id: mov_id, customer_id: params[:customer_id], due_date: params[:due_date])

    if rental.save
      render status: :ok, json: { id: rental.id}
      #update_avail_inventory
    else
      render status: :bad_request, json: { errors: rental.errors.messages}
    end

  end

  def checkin_movie


  end



  private

  def rental_params
    puts params
    params.require(:rental).permit(:customer_id, :due_date, :title)

  end

end

class MoviesController < ApplicationController

  def index
    movies = Movie.all
    render json: movies.as_json(only: [:title, :overview, :release_date, :inventory, :available_inventory])
  end
end

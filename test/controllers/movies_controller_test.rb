require "test_helper"

describe MoviesController do


  KEYS = %w(title overview release_date inventory available_inventory).sort

  describe "index" do
    it "is a working route" do
      get movies_url
      must_respond_with :success
    end

    it "returns json" do
      get movies_url
      response.header["Content-Type"].must_include 'json'
    end

    it "returns an array" do
      get movies_url

      body = JSON.parse(response.body)
      body.must_be_kind_of Array
    end

    it "returns all of the movies" do
      get movies_url

      body = JSON.parse(response.body)

      body.length.must_equal Movie.count
    end

    it "returns movies with the required fields" do
      get movies_url
      body = JSON.parse(response.body)

      body.each do |movie|
        movie.keys.sort.must_equal KEYS
      end
    end
  end

  describe "show" do
    it "can get a movie" do
      get movie_url(movies(:one).title)
      must_respond_with :success

      body = JSON.parse(response.body)
      body.must_be_instance_of Hash
      body.keys.sort.must_equal KEYS
    end

    it "returns nothing true if movie not found" do
      get movie_url("lkasjdpivjdiasd")
      must_respond_with :not_found
      body = JSON.parse(response.body)
      body["errors"].must_equal( "title" => ["Movie 'lkasjdpivjdiasd' not found"])





        # render json:{ errors: { "title": ["Movie '#{params[:title]}' not found"]} }, status: :not_found
    end

    it "Movie found has all the correct information" do
      get movie_url(movies(:one).title)
      body = JSON.parse(response.body)
      KEYS.each do |key|
        body[key].must_equal movies(:one)[key]
      end
    end
  end

  describe "Create" do

    let(:movie_data) {
      {
        title: "Spongebob",
        overview: "Square pants",
        release_date: "2001",
        inventory: 5,
        available_inventory: 0
      }
    }

    it "Can create a new movie" do
      proc {
        post movies_url, params: {movie: movie_data}
      }.must_change 'Movie.count', 1
      must_respond_with :ok
    end

    it "Won't create with missing title" do
      movie_data.delete(:title)
      proc {
        post movies_url, params: {movie: movie_data}
      }.must_change 'Movie.count', 0
      must_respond_with :bad_request
    end

    it "Won't create with missing inventory" do
      movie_data.delete(:inventory)
      proc {
        post movies_url, params: {movie: movie_data}
      }.must_change 'Movie.count', 0
      must_respond_with :bad_request
    end

    it "Won't create with missing release_date" do
      movie_data.delete(:release_date)
      proc {
        post movies_url, params: {movie: movie_data}
      }.must_change 'Movie.count', 0
      must_respond_with :bad_request
    end



  end

end

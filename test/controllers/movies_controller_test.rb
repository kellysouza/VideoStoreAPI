require "test_helper"

describe MoviesController do


KEYS = %w(title overview release_date inventory available_inventory)

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

end
end

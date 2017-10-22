class ListngsController < ApplicationController

  def index
    render json: Listing.order(created_at: :desc).take(10)
  end
end

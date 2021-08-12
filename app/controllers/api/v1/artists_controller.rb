# Artist enpoints implementation
class Api::V1::ArtistsController < ApplicationController

  # GET /artists
  def index
    @artists = Artist.order(popularity: :desc).all
    render :index
  end

end

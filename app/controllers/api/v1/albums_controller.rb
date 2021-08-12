# Album enpoints implementation
class Api::V1::AlbumsController < ApplicationController

  # GET /albums belongs to an artist
  def index
    @albums = Album.where(artist_id: params[:artist_id]).all
    render :index
  end

end

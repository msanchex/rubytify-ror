# Song enpoints implementation
class Api::V1::SongsController < ApplicationController

  # GET /songs belongs to an album
  def index
    @songs = Song.where(album_id: params[:album_id]).all
    render :index
  end

  # GET /random_song belongs to a genre
  def random_song
    offset = rand(Song.joins(album: {artist: :genres}).where('genres.name' => params[:genre_name]).count)
    @song = Song.joins(album: {artist: :genres}).where('genres.name' => params[:genre_name]).offset(offset).first

    if @song.nil?
      render json: {}, status: :not_found
    else
      render :show
    end
  end

end

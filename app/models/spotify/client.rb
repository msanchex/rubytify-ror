module Spotify
  require 'rest-client'
  require 'json'

  # Base class used to communicate with the spotify.
  class Client

    # Base URL to make requests to spotify application.
    BASE_URL = 'https://api.spotify.com'
    # The spotify API version to make requests.
    VERSION = 'v1'

    # Initialize a spotify client object.
    def initialize(access_token)
      @access_token = access_token
    end

    # Search a specific artist and returns its attributes as a hash (key => value)
    # data and returns an empty hash if artist not found.
    def search_artist(artist_name)
      url = base_uri + "/search?q=#{artist_name}&type=artist&limit=1"
      response = make_request(:get, url)
      data = response['artists']['items'][0]
      artist_data = {}

      if not data.nil? and not data.empty?
        artist_data = data
      end

      return artist_data
    end

    # Get an array of album attributes belongs to a specific
    # artist. Every album data is a hash (key => value) and
    # returns an empty array if albums not found.
    # The artist_id param is the spotify_id of the artist
    def albums(artist_id)
      url = base_uri + "/artists/#{artist_id}/albums"
      response = make_request(:get, url)
      albums = response['items']

      if albums.nil? or albums.empty?
        albums = Array.new
      end

      # remove unnecessary data to reduce storage
      albums.each do |album|
        album.delete('artists')
        album.delete('available_markets')
      end

      return albums
    end

    # Get an array of song attributes belongs to a specific
    # album. Every song data is a hash (key => value) and
    # returns an empty array if songs not found.
    # The album_id param is the spotify_id of the album
    def songs(album_id)
      url = base_uri + "/albums/#{album_id}/tracks"
      response = make_request(:get, url)
      songs = response['items']

      if songs.nil? or songs.empty?
        songs = Array.new
      end

      # remove unnecessary data to reduce storage
      songs.each do |song|
        song.delete('artists')
        song.delete('available_markets')
      end

      return songs
    end

    protected

    # Make a request and returns its response parsed as hash.
    # The request is performed using a specific http method and URL.
    def make_request(method, url)
      response = RestClient::Request.execute(
        method: method,
        url: url,
        headers: {Authorization: authorization}
      )

      return JSON.parse(response.to_str)
    end

    # Generate the base URI to comunicate with spotify
    def base_uri
      return BASE_URL + '/' + VERSION
    end

    private

    # The authorization header as a bearer token.
    def authorization
      return  "Bearer #{@access_token.token}"
    end

  end
end

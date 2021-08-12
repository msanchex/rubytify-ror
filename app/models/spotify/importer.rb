module Spotify

  # Class used to import artists information from spotify
  # using a yaml file that contains a list of artists
  class Importer

    # Initialize an importer object indicating
    # the spotify client and the list of
    # artist names to import
    def initialize(client, artist_names)
      @client = client
      @artist_names = artist_names
    end

    # Import artist information about artists in the array
    def import
      @artist_names.each do |name|
        import_artist(name.to_s)
      end
    end

    # Import an artista form spotify
    def import_artist(artist_name)
      artist_data = @client.search_artist(artist_name)

      if not artist_data.empty?
        artist = Artist.find_by(spotify_id: artist_data['spotify_id'])

        # if not exsits, create a new one
        if artist.nil?
          artist = Artist.create(
            spotify_id: artist_data['id'],
            spotify_url: spotify_url_data(artist_data),
            name: artist_data['name'],
            image: image_data(artist_data),
            popularity: artist_data['popularity']
          )
        end

        import_genres(artist, artist_data['genres'])
        import_albums(artist)

      end
    end

    # Create and assign genres to an artist
    def import_genres(artist, genres)
      # create and assign every genre to the artist
      genres.each do |genre_name|
        genre = Genre.find_by(name: genre_name)

        if genre.nil?
          genre = Genre.create(name: genre_name)
        end

        artist.genres << genre
      end
    end

    # Create and assign albums to an artist
    def import_albums(artist)
      albums_data = @client.albums(artist.spotify_id)

      albums_data.each do |data|
        # create album without assign it to the albums of the artist
        # to reduce memory storage
        album = Album.create(
          artist_id: artist.id,
          spotify_id: data['id'],
          spotify_url: spotify_url_data(data),
          name: data['name'],
          image: image_data(data),
          total_tracks: data['total_tracks']
        )

        import_songs(album)
      end
    end

    # Create and assign songs to an album
    def import_songs(album)
      songs_data = @client.songs(album.spotify_id)

      songs_data.each do |data|
        # create song without assign it to the songs of the album
        # to reduce memory storage
        song = Song.create(
          album_id: album.id,
          spotify_id: data['id'],
          spotify_url: spotify_url_data(data),
          name: data['name'],
          preview_url: data['preview_url'],
          duration_ms: data['duration_ms'],
          explicit: data['explicit']
        )
      end
    end

    private

    # Extract image url from data
    def image_data(data)
      image = nil

      if not data['images'].empty? and not data['images'][0]['url'].nil?
        image = data['images'][0]['url']
      end

      return image
    end

    # Extract spotify url from data
    def spotify_url_data(data)
      url = nil

      if not data['external_urls'].nil? and not data['external_urls']['spotify'].nil?
        url = data['external_urls']['spotify']
      end

      return url
    end

  end
end

namespace :importer do
  desc "Import artists information from spotify"
  task import_spotify: :environment do
    # Read YAML file
    file_data = YAML.load(File.read("#{Rails.root}/files/artists.yaml"))
    artist_names = []

    if not file_data['artists'].nil? and not file_data['artists'].empty?
      artist_names = file_data['artists']
    end

    token = Spotify::AccessToken.new('c9036492b8a24b49b667dadd1b56157f', 'c8434cd9bcd54f158cbad32aeef65aba')
    client = Spotify::Client.new(token)
    importer = Spotify::Importer.new(client, artist_names)
    importer.import
  end

end

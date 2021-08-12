Rails.application.routes.draw do

  namespace :api, defaults: {format: :json} do
    namespace :v1 do
      get '/artists', to: 'artists#index'
      get '/artists/:artist_id/albums', to: 'albums#index'
      get '/albums/:album_id/songs', to: 'songs#index'
      get '/genres/:genre_name/random_song', to: 'songs#random_song'
    end
  end

end

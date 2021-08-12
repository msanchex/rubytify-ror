json.data do
    json.array! @artists, partial: 'artist', as: :artist
    #json.partial! 'user', collection: @users, as: :user
end

json.data do
    json.array! @albums, partial: 'album', as: :album
end

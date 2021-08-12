json.data do
    json.array! @songs, partial: 'song', as: :song
end

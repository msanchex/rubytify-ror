json.data do
  json.partial! partial: 'song', locals: {song: @song}
end

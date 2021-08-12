class Artist < ApplicationRecord
  has_many :albums, dependent: :destroy
  has_and_belongs_to_many :genres

  # Generate an array of genre names
  def genre_names
    names = Array.new

    genres.each do |genre|
      names.push(genre.name)
    end

    return names
  end
end

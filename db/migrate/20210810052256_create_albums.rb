class CreateAlbums < ActiveRecord::Migration[6.1]
  def change
    create_table :albums do |t|
      t.string :spotify_id
      t.string :spotify_url
      t.string :name
      t.string :image
      t.integer :total_tracks
      t.references :artist, null: false, foreign_key: true

      t.timestamps
    end
  end
end

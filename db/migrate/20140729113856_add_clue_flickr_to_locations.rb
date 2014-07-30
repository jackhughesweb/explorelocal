class AddClueFlickrToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :clue_flickr, :string
  end
end

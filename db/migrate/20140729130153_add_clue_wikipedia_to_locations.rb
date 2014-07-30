class AddClueWikipediaToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :clue_wikipedia, :string
  end
end

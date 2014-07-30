class AddWikipediaToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :clue_wikipedia_text, :text
    add_column :locations, :clue_wikipedia_link, :string
    remove_column :locations, :clue_wikipedia, :string
    remove_column :locations, :clue_wikipedia_title, :string
  end
end

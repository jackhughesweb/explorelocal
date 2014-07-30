class AddIndexToGames < ActiveRecord::Migration
  def change
    add_index :games, :slug, unique: true
  end
end

class AddLatitudeAndLongitudeAndRadiusToGames < ActiveRecord::Migration
  def change
    add_column :games, :latitude, :decimal, :default => 52.4805801
    add_column :games, :longitude, :decimal, :default => -1.8927344
    add_column :games, :radius, :integer, :default => 15
  end
end

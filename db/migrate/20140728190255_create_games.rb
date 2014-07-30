class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.string :slug
      t.integer :location1
      t.integer :location2
      t.integer :location3
      t.integer :location4

      t.timestamps
    end
  end
end

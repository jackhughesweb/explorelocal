class CreateGameReports < ActiveRecord::Migration
  def change
    create_table :game_reports do |t|
      t.string :location
      t.integer :radius
      t.text :message
      t.string :name
      t.string :email

      t.timestamps
    end
  end
end

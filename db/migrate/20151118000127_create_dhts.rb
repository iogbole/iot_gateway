class CreateDhts < ActiveRecord::Migration
  def change
    create_table :dhts do |t|
      t.integer :chipid
      t.string :location
      t.text :description
      t.float :temperature
      t.float :humidity

      t.timestamps null: false
    end
  end
end

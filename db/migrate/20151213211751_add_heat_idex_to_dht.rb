class AddHeatIdexToDht < ActiveRecord::Migration
  def change
    add_column :dhts, :heat_index, :float
  end
end

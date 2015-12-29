class AddIndexToDht < ActiveRecord::Migration
  def change
    add_index :dhts, :created_at
  end
end

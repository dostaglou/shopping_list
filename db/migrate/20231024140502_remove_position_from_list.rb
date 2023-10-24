class RemovePositionFromList < ActiveRecord::Migration[7.0]
  def change
    remove_column :lists, :position
  end
end

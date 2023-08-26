class CreateSharedLists < ActiveRecord::Migration[7.0]
  def change
    create_table :shared_lists do |t|
      t.references :list, foreign_key: { to_table: :lists }, null: false
      t.references :friendship, foreign_key: { to_table: :friendships }, null: false
      t.index [:list_id, :friendship_id], unique: true
      t.timestamps
    end
  end
end

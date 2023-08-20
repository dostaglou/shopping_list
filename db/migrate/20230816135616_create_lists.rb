class CreateLists < ActiveRecord::Migration[7.0]
  def change
    create_table :lists do |t|
      t.references :user, null: false, foreign_key: { to_table: :users }
      t.string :title, null: false
      t.integer :position, null: false, default: 0

      t.timestamps
    end
  end
end

class CreateFriendships < ActiveRecord::Migration[7.0]
  def change
    create_table :friendships do |t|
      t.references :inviter, null: false, foreign_key: { to_table: :users }
      t.string :invited_email, null: false
      t.references :invited, null: false, foreign_key: { to_table: :users }, null: true
      t.integer :status, default: 0, null: false

      t.timestamps
    end
  end
end



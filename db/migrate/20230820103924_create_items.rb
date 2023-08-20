class CreateItems < ActiveRecord::Migration[7.0]
  def change
    create_table :items do |t|
      t.references :list, foregin_key: { to_table: :lists }, null: false
      t.string :name, null: false
      t.string :note, null: true
      t.integer :quantity, default: 0, null: false
      t.integer :status, default: 0, null: false

      t.timestamps
    end
  end
end

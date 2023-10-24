# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_10_24_140502) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "friendships", force: :cascade do |t|
    t.bigint "inviter_id", null: false
    t.string "invited_email", null: false
    t.bigint "invited_id"
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["invited_id"], name: "index_friendships_on_invited_id"
    t.index ["inviter_id"], name: "index_friendships_on_inviter_id"
  end

  create_table "items", force: :cascade do |t|
    t.bigint "list_id", null: false
    t.string "name", null: false
    t.string "note"
    t.integer "quantity", default: 0, null: false
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["list_id"], name: "index_items_on_list_id"
  end

  create_table "lists", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "title", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_lists_on_user_id"
  end

  create_table "shared_lists", force: :cascade do |t|
    t.bigint "list_id", null: false
    t.bigint "friendship_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["friendship_id"], name: "index_shared_lists_on_friendship_id"
    t.index ["list_id", "friendship_id"], name: "index_shared_lists_on_list_id_and_friendship_id", unique: true
    t.index ["list_id"], name: "index_shared_lists_on_list_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "username", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "friendships", "users", column: "invited_id"
  add_foreign_key "friendships", "users", column: "inviter_id"
  add_foreign_key "lists", "users"
  add_foreign_key "shared_lists", "friendships"
  add_foreign_key "shared_lists", "lists"
end

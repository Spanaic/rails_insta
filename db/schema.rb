# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_09_26_034811) do

  create_table "favorites", force: :cascade do |t|
    t.integer "user_id"
    t.integer "post_image_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "hashtags", force: :cascade do |t|
    t.string "hashname"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["hashname"], name: "index_hashtags_on_hashname", unique: true
  end

  create_table "hashtags_post_images", id: false, force: :cascade do |t|
    t.integer "post_image_id"
    t.integer "hashtag_id"
    t.index ["hashtag_id"], name: "index_hashtags_post_images_on_hashtag_id"
    t.index ["post_image_id"], name: "index_hashtags_post_images_on_post_image_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.integer "visitor_id", null: false
    t.integer "visited_id", null: false
    t.integer "post_image_id"
    t.integer "post_comment_id"
    t.string "action", null: false
    t.boolean "checked", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_comment_id"], name: "index_notifications_on_post_comment_id"
    t.index ["post_image_id"], name: "index_notifications_on_post_image_id"
    t.index ["visited_id"], name: "index_notifications_on_visited_id"
    t.index [nil], name: "index_notifications_on_visiter_id"
  end

  create_table "post_comments", force: :cascade do |t|
    t.text "comment"
    t.integer "post_image_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "post_comments_users", id: false, force: :cascade do |t|
    t.integer "post_comment_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_comment_id"], name: "index_post_comments_users_on_post_comment_id"
    t.index ["user_id"], name: "index_post_comments_users_on_user_id"
  end

  create_table "post_images", force: :cascade do |t|
    t.integer "user_id"
    t.string "post_image_id"
    t.text "caption"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "favorites_count"
  end

  create_table "relationships", force: :cascade do |t|
    t.integer "following_id"
    t.integer "follower_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "name"
    t.string "profile_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "profile_image_id"
    t.text "introduction"
    t.string "uid"
    t.string "provider"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["profile_name"], name: "index_users_on_profile_name", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end

# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20131107123623) do

  create_table "cards", force: true do |t|
    t.integer  "scannable_id"
    t.string   "scannable_type"
    t.string   "uid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "orders", force: true do |t|
    t.integer  "shop_id"
    t.float    "total"
    t.boolean  "cancelled",  default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "orders_products", id: false, force: true do |t|
    t.integer "order_id"
    t.integer "product_id"
  end

  add_index "orders_products", ["order_id", "product_id"], name: "index_orders_products_on_order_id_and_product_id", using: :btree

  create_table "orders_users", id: false, force: true do |t|
    t.integer "order_id"
    t.integer "user_id"
  end

  add_index "orders_users", ["order_id", "user_id"], name: "index_orders_users_on_order_id_and_user_id", using: :btree

  create_table "products", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.float    "price"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "parent_id",   default: 0
    t.float    "parent_qty",  default: 0.0
  end

  create_table "products_shops", id: false, force: true do |t|
    t.integer "product_id"
    t.integer "shop_id"
  end

  add_index "products_shops", ["product_id", "shop_id"], name: "index_products_shops_on_product_id_and_shop_id", using: :btree

  create_table "shops", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "level"
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "shops_specials", id: false, force: true do |t|
    t.integer "shop_id"
    t.integer "special_id"
  end

  add_index "shops_specials", ["shop_id", "special_id"], name: "index_shops_specials_on_shop_id_and_special_id", using: :btree

  create_table "specials", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.string   "function"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "stocks", force: true do |t|
    t.integer  "qty"
    t.integer  "shop_id"
    t.integer  "product_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.float    "amount",     default: 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end

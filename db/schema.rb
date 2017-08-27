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

ActiveRecord::Schema.define(version: 20170826164029) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "listings", force: :cascade do |t|
    t.integer "rmls_number"
    t.text "description"
    t.string "nhoodbldg"
    t.decimal "taxyr"
    t.integer "yrbuilt"
    t.string "elem"
    t.decimal "baths"
    t.integer "beds"
    t.integer "sqft"
    t.integer "price"
    t.string "status"
    t.string "county"
    t.string "address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["price"], name: "index_listings_on_price"
    t.index ["rmls_number"], name: "index_listings_on_rmls_number", unique: true
    t.index ["sqft"], name: "index_listings_on_sqft"
    t.index ["status"], name: "index_listings_on_status"
    t.index ["yrbuilt"], name: "index_listings_on_yrbuilt"
  end

  create_table "price_histories", force: :cascade do |t|
    t.integer "rmls_number"
    t.integer "old_price"
    t.integer "new_price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end

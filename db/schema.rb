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

ActiveRecord::Schema.define(version: 20141120151429) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "days", force: true do |t|
    t.integer  "point_time_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "days", ["point_time_id"], name: "index_days_on_point_times_id", using: :btree

  create_table "hours", force: true do |t|
    t.integer  "point_time_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "hours", ["point_time_id"], name: "index_hours_on_point_times_id", using: :btree

  create_table "inverters", force: true do |t|
    t.string   "name"
    t.string   "ip"
    t.string   "user"
    t.string   "pass"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "months", force: true do |t|
    t.integer  "point_time_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "months", ["point_time_id"], name: "index_months_on_point_times_id", using: :btree

  create_table "point_datas", force: true do |t|
    t.integer  "inverter_id"
    t.integer  "point_time_id"
    t.float    "value"
    t.string   "unit"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "point_datas", ["inverter_id"], name: "index_point_data_on_inverter_id", using: :btree
  add_index "point_datas", ["point_time_id"], name: "index_point_data_on_point_times_id", using: :btree

  create_table "point_times", force: true do |t|
    t.datetime "time"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "weeks", force: true do |t|
    t.integer  "point_time_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "weeks", ["point_time_id"], name: "index_weeks_on_point_times_id", using: :btree

  create_table "who", force: true do |t|
    t.string  "firstname",   limit: 40
    t.string  "lastname",    limit: 40
    t.integer "workshop_id"
  end

  create_table "workshops", force: true do |t|
    t.time "hr"
  end

  create_table "years", force: true do |t|
    t.integer  "point_time_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "years", ["point_time_id"], name: "index_years_on_point_times_id", using: :btree

  create_table "zones", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "zones_inverters", id: false, force: true do |t|
    t.integer "zone_id"
    t.integer "inverter_id"
  end

end

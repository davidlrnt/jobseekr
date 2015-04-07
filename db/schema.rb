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

ActiveRecord::Schema.define(version: 20150406172332) do

  create_table "cities", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "job_users", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "job_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "job_users", ["job_id"], name: "index_job_users_on_job_id"
  add_index "job_users", ["user_id"], name: "index_job_users_on_user_id"

  create_table "jobs", force: :cascade do |t|
    t.float    "lat"
    t.float    "long"
    t.string   "company"
    t.string   "position"
    t.string   "country"
    t.string   "state"
    t.string   "url"
    t.integer  "city_id"
    t.date     "date_posted"
    t.text     "description"
    t.integer  "job_key"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "jobs", ["city_id"], name: "index_jobs_on_city_id"

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "provider"
    t.string   "uid"
    t.string   "img_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

ActiveRecord::Schema.define(version: 20150406172332) do

  create_table "cities", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "job_users", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "job_id"
    t.boolean  "applied",    default: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
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
    t.string   "job_key"
    t.integer  "creator_id"
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

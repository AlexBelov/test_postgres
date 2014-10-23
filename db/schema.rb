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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20141016084552) do

  create_table "alerts", :force => true do |t|
    t.string   "name"
    t.datetime "deleted_at"
  end

  add_index "alerts", ["name"], :name => "alerts_name_idx"

  create_table "alerts_active", :id => false, :force => true do |t|
    t.integer  "id",         :null => false
    t.string   "name"
    t.datetime "deleted_at"
  end

  add_index "alerts_active", ["name"], :name => "index_alerts_active_on_name"

  create_table "alerts_inactive", :id => false, :force => true do |t|
    t.integer  "id",         :null => false
    t.string   "name"
    t.datetime "deleted_at"
  end

  add_index "alerts_inactive", ["deleted_at"], :name => "index_alerts_inactive_on_deleted_at"

  create_table "alerts_old", :force => true do |t|
    t.string   "name"
    t.datetime "deleted_at"
  end

  add_index "alerts_old", ["name"], :name => "index_alerts_on_name"

  create_table "wants", :force => true do |t|
    t.string   "name"
    t.integer  "alert_id"
    t.datetime "deleted_at"
  end

end

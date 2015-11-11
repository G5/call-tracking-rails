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

ActiveRecord::Schema.define(version: 20151111012927) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "g5_authenticatable_roles", force: :cascade do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "g5_authenticatable_roles", ["name", "resource_type", "resource_id"], name: "index_g5_authenticatable_roles_on_name_and_resource", using: :btree
  add_index "g5_authenticatable_roles", ["name"], name: "index_g5_authenticatable_roles_on_name", using: :btree

  create_table "g5_authenticatable_users", force: :cascade do |t|
    t.string   "email",              default: "",   null: false
    t.string   "provider",           default: "g5", null: false
    t.string   "uid",                               null: false
    t.string   "g5_access_token"
    t.integer  "sign_in_count",      default: 0,    null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "phone_number"
    t.string   "title"
    t.string   "organization_name"
  end

  add_index "g5_authenticatable_users", ["email"], name: "index_g5_authenticatable_users_on_email", unique: true, using: :btree
  add_index "g5_authenticatable_users", ["provider", "uid"], name: "index_g5_authenticatable_users_on_provider_and_uid", unique: true, using: :btree

  create_table "g5_authenticatable_users_roles", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "g5_authenticatable_users_roles", ["user_id", "role_id"], name: "index_g5_authenticatable_users_roles_on_user_id_and_role_id", using: :btree

  create_table "g5_updatable_clients", force: :cascade do |t|
    t.string   "uid"
    t.string   "urn"
    t.json     "properties"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
  end

  add_index "g5_updatable_clients", ["name"], name: "index_g5_updatable_clients_on_name", using: :btree
  add_index "g5_updatable_clients", ["uid"], name: "index_g5_updatable_clients_on_uid", using: :btree
  add_index "g5_updatable_clients", ["urn"], name: "index_g5_updatable_clients_on_urn", using: :btree

  create_table "g5_updatable_locations", force: :cascade do |t|
    t.string   "uid"
    t.string   "urn"
    t.string   "client_uid"
    t.json     "properties"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
  end

  add_index "g5_updatable_locations", ["name"], name: "index_g5_updatable_locations_on_name", using: :btree
  add_index "g5_updatable_locations", ["uid"], name: "index_g5_updatable_locations_on_uid", using: :btree
  add_index "g5_updatable_locations", ["urn"], name: "index_g5_updatable_locations_on_urn", using: :btree

  create_table "lead_sources", force: :cascade do |t|
    t.string   "name",              null: false
    t.string   "incoming_number",   null: false
    t.string   "forwarding_number"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "leads", force: :cascade do |t|
    t.integer  "lead_source_id",              null: false
    t.string   "phone_number",                null: false
    t.string   "city"
    t.string   "state"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.json     "properties",     default: {}, null: false
  end

  add_foreign_key "leads", "lead_sources"
end

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

ActiveRecord::Schema[8.1].define(version: 2026_10_27_162059) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "activities", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "activity_category_id", null: false
    t.bigint "unit_id", null: false
    t.datetime "archived_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["activity_category_id"], name: "index_activities_on_activity_category_id"
    t.index ["name"], name: "index_active_activities_on_name", unique: true, where: "(archived_at IS NULL)"
    t.index ["unit_id"], name: "index_activities_on_unit_id"
  end

  create_table "activity_categories", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_activity_categories_on_name", unique: true
  end

  create_table "activity_templates", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "activity_category_id", null: false
    t.bigint "unit_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["activity_category_id"], name: "index_activity_templates_on_activity_category_id"
    t.index ["name"], name: "index_activity_templates_on_name", unique: true
    t.index ["unit_id"], name: "index_activity_templates_on_unit_id"
  end

  create_table "unit_categories", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_unit_categories_on_name", unique: true
  end

  create_table "units", force: :cascade do |t|
    t.bigint "unit_category_id", null: false
    t.string "code", null: false
    t.string "name", null: false
    t.string "symbol"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_units_on_code", unique: true
    t.index ["unit_category_id"], name: "index_units_on_unit_category_id"
  end

  add_foreign_key "activities", "activity_categories", on_delete: :restrict
  add_foreign_key "activities", "units", on_delete: :restrict
  add_foreign_key "activity_templates", "activity_categories", on_delete: :restrict
  add_foreign_key "activity_templates", "units", on_delete: :restrict
  add_foreign_key "units", "unit_categories"
end

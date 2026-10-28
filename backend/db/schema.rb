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

ActiveRecord::Schema[8.1].define(version: 2026_10_28_093249) do
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

  create_table "entries", force: :cascade do |t|
    t.bigint "activity_id", null: false
    t.decimal "value", precision: 12, scale: 3, null: false
    t.datetime "performed_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["activity_id", "performed_at"], name: "index_entries_on_activity_id_and_performed_at"
    t.check_constraint "value > 0::numeric", name: "entries_value_positive"
  end

  create_table "goal_versions", force: :cascade do |t|
    t.bigint "goal_id", null: false
    t.decimal "target_value", precision: 12, scale: 3, null: false
    t.datetime "effective_from", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["goal_id", "effective_from"], name: "index_goal_versions_on_goal_and_effective_from", unique: true
    t.check_constraint "target_value > 0::numeric", name: "goal_versions_target_value_positive"
  end

  create_table "goals", force: :cascade do |t|
    t.bigint "activity_id", null: false
    t.string "period_type", null: false
    t.string "period_unit", null: false
    t.integer "period_value", default: 1, null: false
    t.datetime "archived_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["activity_id", "period_type", "period_unit", "period_value"], name: "index_goals_on_active_activity_and_period", unique: true, where: "(archived_at IS NULL)"
    t.index ["activity_id"], name: "index_goals_on_activity_id"
    t.check_constraint "period_value > 0", name: "goals_period_value_positive"
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
  add_foreign_key "entries", "activities", on_delete: :restrict
  add_foreign_key "goal_versions", "goals", on_delete: :restrict
  add_foreign_key "goals", "activities", on_delete: :restrict
  add_foreign_key "units", "unit_categories"
end

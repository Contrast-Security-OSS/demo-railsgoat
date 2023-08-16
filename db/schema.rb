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

ActiveRecord::Schema.define(version: 2023_08_01_225422) do

  create_table "analytics", force: :cascade do |t|
    t.string "ip_address"
    t.string "referrer"
    t.string "user_agent"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "benefits", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "key_managements", force: :cascade do |t|
    t.string "iv"
    t.integer "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "messages", force: :cascade do |t|
    t.integer "creator_id"
    t.integer "receiver_id"
    t.text "message"
    t.boolean "read"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "paid_time_offs", force: :cascade do |t|
    t.integer "user_id"
    t.integer "sick_days_taken"
    t.integer "sick_days_earned"
    t.integer "pto_taken"
    t.integer "pto_earned"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pays", force: :cascade do |t|
    t.integer "user_id"
    t.string "bank_account_num"
    t.string "bank_routing_num"
    t.integer "percent_of_deposit"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "performances", force: :cascade do |t|
    t.integer "user_id"
    t.date "date_submitted"
    t.integer "score"
    t.string "comments"
    t.integer "reviewer"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "retirements", force: :cascade do |t|
    t.string "total"
    t.string "employee_contrib"
    t.string "employer_contrib"
    t.integer "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "schedules", force: :cascade do |t|
    t.string "event_type"
    t.date "date_begin"
    t.date "date_end"
    t.string "event_name"
    t.string "event_desc"
    t.integer "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "password"
    t.boolean "admin"
    t.string "first_name"
    t.string "last_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "auth_token"
  end

  create_table "work_infos", force: :cascade do |t|
    t.integer "user_id"
    t.string "income"
    t.string "bonuses"
    t.integer "years_worked"
    t.string "SSN"
    t.date "DoB"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.binary "encrypted_ssn"
  end

end

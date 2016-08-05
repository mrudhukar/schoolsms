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

ActiveRecord::Schema.define(version: 20160805111512) do

  create_table "messages", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.text     "content",    limit: 65535
    t.text     "criteria",   limit: 65535
    t.text     "response",   limit: 65535
    t.integer  "status",                   default: 0
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
  end

  create_table "parents", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "student_id"
    t.string   "phone"
    t.string   "name"
    t.string   "email"
    t.string   "relation"
    t.string   "occupation"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "qualification"
    t.string   "income"
    t.index ["student_id"], name: "index_parents_on_student_id", using: :btree
  end

  create_table "student_years", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "student_id"
    t.integer  "academic_year",                     null: false
    t.string   "classroom",                         null: false
    t.string   "section"
    t.string   "branch",        default: "Main",    null: false
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.string   "roll_number"
    t.boolean  "fees_payed"
    t.string   "medium",        default: "English"
    t.index ["student_id"], name: "index_student_years_on_student_id", using: :btree
  end

  create_table "students", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "first_name",                                 null: false
    t.string   "middle_name"
    t.string   "last_name"
    t.string   "phone"
    t.string   "email"
    t.date     "date_of_birth"
    t.date     "joined_on"
    t.date     "left_on"
    t.string   "gender"
    t.string   "caste"
    t.integer  "status",                         default: 0, null: false
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.string   "aadhar_number"
    t.string   "admission_number"
    t.string   "religion"
    t.string   "ward_type"
    t.string   "mother_tounge"
    t.string   "disability"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.text     "address",          limit: 65535
    t.text     "joined_class",     limit: 65535
    t.text     "conduct",          limit: 65535
    t.text     "remarks",          limit: 65535
    t.string   "qualified_class"
    t.date     "tc_apply_date"
    t.date     "relieving_date"
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "email",                  default: "", null: false
    t.string   "name",                   default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

end

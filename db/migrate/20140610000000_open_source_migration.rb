class OpenSourceMigration < ActiveRecord::Migration
  def up


  create_table "kpi_results", :force => true do |t|
    t.date     "date"
    t.float    "today"
    t.float    "t7days"
    t.float    "t30days"
    t.float    "today_pct_change"
    t.float    "t7days_pct_change"
    t.float    "t30days_pct_change"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "ytd"
    t.integer  "kpi_id"
    t.float    "qtd"
  end

  add_index "kpi_results", ["date"], :name => "index_daily_kpis_on_date"
  add_index "kpi_results", ["kpi_id", "date"], :name => "index_kpi_results_on_kpi_id_and_date"
  add_index "kpi_results", ["kpi_id"], :name => "index_daily_kpis_on_kpi_id"

  create_table "kpis", :force => true do |t|
    t.string   "name",                          :null => false
    t.text     "query",                         :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active",      :default => true, :null => false
    t.string   "data_source"
  end

  create_table "questions", :force => true do |t|
    t.string   "name",         :null => false
    t.text     "description",  :null => false
    t.text     "question_sql", :null => false
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.string   "data_source"
  end

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       :limit => 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "users", :force => true do |t|
    t.string   "name",          :null => false
    t.integer  "omniauth_id",  :null => false
    t.string   "email_address"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "users", ["omniauth_id"], :name => "index_users_on_omniauth_id", :unique => true

end
end

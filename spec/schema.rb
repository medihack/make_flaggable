ActiveRecord::Schema.define :version => 0 do
  create_table :flaggable_models, :force => true do |t|
    t.string :name
    t.integer :flaggings_count, default: 0
  end

  create_table :flagger_models, :force => true do |t|
    t.string :name
    t.integer :flaggings_count, default: 0
  end

  create_table :flagger_once_models, :force => true do |t|
    t.string :name
    t.integer :flaggings_count, default: 0
  end

  create_table :invalid_flaggable_models, :force => true do |t|
    t.string :name
    t.integer :flaggings_count, default: 0
  end

  create_table :another_flaggable_models, :force => true do |t|
    t.string :name
    t.integer :flaggings_count, default: 0
  end


  create_table :flaggings, :force => true do |t|
     t.string :flaggable_type
     t.integer :flaggable_id
     t.string :flagger_type
     t.integer :flagger_id
     t.text :reason

     t.timestamps
  end

  add_index :flaggings, [:flaggable_type, :flaggable_id]
  add_index :flaggings, [:flagger_type, :flagger_id, :flaggable_type, :flaggable_id], :name => "access_flaggings"
end

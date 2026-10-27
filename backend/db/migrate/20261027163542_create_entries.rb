class CreateEntries < ActiveRecord::Migration[8.1]
  def change
    create_table :entries do |t|
      t.references :activity, null: false,
                              foreign_key: { on_delete: :restrict },
                              index: false
      t.decimal :value, precision: 12, scale: 3, null: false
      t.datetime :performed_at, null: false

      t.timestamps
    end

    add_check_constraint :entries, "value > 0",
                         name: "entries_value_positive"

    add_index :entries, [ :activity_id, :performed_at ]
  end
end

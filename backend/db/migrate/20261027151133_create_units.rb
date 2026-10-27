class CreateUnits < ActiveRecord::Migration[8.1]
  def change
    create_table :units do |t|
      t.references :unit_category, null: false, foreign_key: true

      t.string :code, null: false
      t.string :name, null: false
      t.string :symbol

      t.timestamps
    end

    add_index :units, :code, unique: true
  end
end

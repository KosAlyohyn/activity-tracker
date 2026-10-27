class CreateUnitCategories < ActiveRecord::Migration[8.1]
  def change
    create_table :unit_categories do |t|
      t.string :name, null: false

      t.timestamps
    end

    add_index :unit_categories, :name, unique: true
  end
end

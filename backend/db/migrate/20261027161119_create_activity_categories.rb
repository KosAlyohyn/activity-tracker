class CreateActivityCategories < ActiveRecord::Migration[8.1]
  def change
    create_table :activity_categories do |t|
      t.string :name, null: false

      t.timestamps
    end

    add_index :activity_categories, :name, unique: true
  end
end

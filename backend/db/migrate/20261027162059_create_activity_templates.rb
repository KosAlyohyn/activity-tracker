class CreateActivityTemplates < ActiveRecord::Migration[8.1]
  def change
    create_table :activity_templates do |t|
      t.string :name, null: false
      t.references :activity_category, null: false, foreign_key: { on_delete: :restrict }
      t.references :unit, null: false, foreign_key: { on_delete: :restrict }

      t.timestamps
    end

    add_index :activity_templates, :name, unique: true
  end
end

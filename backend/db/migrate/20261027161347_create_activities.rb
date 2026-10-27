class CreateActivities < ActiveRecord::Migration[8.1]
  def change
    create_table :activities do |t|
      t.string :name, null: false
      t.references :activity_category, null: false, foreign_key: { on_delete: :restrict }
      t.references :unit, null: false, foreign_key: { on_delete: :restrict }
      t.datetime :archived_at

      t.timestamps
    end

    add_index :activities, :name,
              unique: true,
              where: "archived_at IS NULL",
              name: "index_active_activities_on_name"
  end
end

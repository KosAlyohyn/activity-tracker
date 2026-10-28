class CreateGoalVersions < ActiveRecord::Migration[8.1]
  def change
    create_table :goal_versions do |t|
      t.references :goal, null: false,
                          foreign_key: { on_delete: :restrict },
                          index: false

      t.decimal :target_value, precision: 12, scale: 3, null: false
      t.datetime :effective_from, null: false

      t.timestamps
    end

    add_check_constraint :goal_versions,
                         "target_value > 0",
                         name: "goal_versions_target_value_positive"

    add_index :goal_versions,
              [ :goal_id, :effective_from ],
              unique: true,
              name: "index_goal_versions_on_goal_and_effective_from"
  end
end

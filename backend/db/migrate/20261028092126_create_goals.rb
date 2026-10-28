class CreateGoals < ActiveRecord::Migration[8.1]
  # rubocop:disable-next Metrics/MethodLength
  def change
    create_table :goals do |t|
      t.references :activity, null: false,
                              foreign_key: { on_delete: :restrict }

      t.string :period_type, null: false
      t.string :period_unit, null: false
      t.integer :period_value, null: false, default: 1

      t.datetime :archived_at

      t.timestamps
    end

    add_check_constraint :goals,
                         "period_value > 0",
                         name: "goals_period_value_positive"

    add_index :goals,
              [ :activity_id, :period_type, :period_unit, :period_value ],
              unique: true,
              where: "archived_at IS NULL",
              name: "index_goals_on_active_activity_and_period"
  end
end

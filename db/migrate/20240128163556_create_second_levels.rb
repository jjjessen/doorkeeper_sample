class CreateSecondLevels < ActiveRecord::Migration[7.1]
  def change
    create_table :second_levels do |t|
      t.references :first_level, null: false, foreign_key: true
      t.string :data

      t.timestamps
    end
  end
end

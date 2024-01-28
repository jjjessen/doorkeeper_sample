class CreateFirstLevels < ActiveRecord::Migration[7.1]
  def change
    create_table :first_levels do |t|
      t.references :team, null: false, foreign_key: true
      t.string :data

      t.timestamps
    end
  end
end

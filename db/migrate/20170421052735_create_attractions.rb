class CreateAttractions < ActiveRecord::Migration[5.0]
  def change
    create_table :attractions do |t|
      t.string :name
      t.integer :algorithm_id
      t.timestamps null: true
    end
  end
end

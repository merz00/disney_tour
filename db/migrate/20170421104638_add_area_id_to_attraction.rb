class AddAreaIdToAttraction < ActiveRecord::Migration[5.0]
  def change
    add_column :attractions, :area_id, :integer
  end
end

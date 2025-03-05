class CreateLocations < ActiveRecord::Migration[8.0]
  def change
    create_table :locations, force: true do |t|
      t.integer :location_type
      t.integer :location_id
      t.string :name
    end
  end
end

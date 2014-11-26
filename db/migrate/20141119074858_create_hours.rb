class CreateHours < ActiveRecord::Migration
  def change
    create_table :hours do |t|
      t.references :point_time, index: true

      t.timestamps
    end
  end
end

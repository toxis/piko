class CreateDays < ActiveRecord::Migration
  def change
    create_table :days do |t|
      t.references :point_time, index: true

      t.timestamps
    end
  end
end

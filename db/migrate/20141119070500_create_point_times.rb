class CreatePointTimes < ActiveRecord::Migration
  def change
    create_table :point_times do |t|
      t.datetime :time

      t.timestamps
    end
  end
end

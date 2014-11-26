class CreatePointData < ActiveRecord::Migration
  def change
    create_table :point_datas do |t|
      t.references :inverter, index: true
      t.references :point_time, index: true
      t.float :value
      t.string :unit

      t.timestamps
    end
  end
end

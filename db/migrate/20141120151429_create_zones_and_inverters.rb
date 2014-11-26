class CreateZonesAndInverters < ActiveRecord::Migration
  def change
    create_table :zones_inverters, id: false do |t|
      t.belongs_to :zone
      t.belongs_to :inverter
    end
  end
end

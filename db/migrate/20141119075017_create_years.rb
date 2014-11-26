class CreateYears < ActiveRecord::Migration
  def change
    create_table :years do |t|
      t.references :point_time, index: true

      t.timestamps
    end
  end
end

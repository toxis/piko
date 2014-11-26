class CreateMonths < ActiveRecord::Migration
  def change
    create_table :months do |t|
      t.references :point_time, index: true

      t.timestamps
    end
  end
end

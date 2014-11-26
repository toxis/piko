class CreateInverters < ActiveRecord::Migration
  def change
    create_table :inverters do |t|
      t.string :name
      t.string :ip
      t.string :user
      t.string :pass

      t.timestamps
    end
  end
end

class Inverter < ActiveRecord::Base
  has_and_belongs_to_many :zones, join_table: :zones_inverters
  has_many :point_datas
end

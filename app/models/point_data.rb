class PointData < ActiveRecord::Base
  self.table_name = "point_datas"
  
  belongs_to :inverter
  belongs_to :point_times
  has_many :hours, through: :point_times
  
end

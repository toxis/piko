class PointTime < ActiveRecord::Base
  has_many :point_datas
  has_many :hours
  has_many :days
  has_many :weeks
  has_many :years
end

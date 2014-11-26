class Zone < ActiveRecord::Base
  has_and_belongs_to_many :inverters, join_table: :zones_inverters
  
  validates :name, :uniqueness => { :case_sensitive => false } # name is used in JS (highcharts)
end

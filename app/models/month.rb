class Month < ActiveRecord::Base
  belongs_to :point_times
  
  def self.compute_month
    now = DateTime.now
    end_time = DateTime.new(now.year, now.month, now.day, now.hour, 0)
    start_time = end_time - 8.hours
    
    average = {}
    nb = 0
    
    inverters = Inverter.all
    inverters.each do |inverter|
      average[inverter.id] = 0.0
    end    
    
    times = PointTime.joins(:weeks, :point_datas).where(time: start_time..end_time).includes(:weeks, :point_datas)
    times.each do |time|
      # get data (for each inverter)
      time.point_datas.each do |data|
        average[data.inverter_id] = average[data.inverter_id] + data.value
      end
      nb = nb + 1      
    end
    
    average.each do |key, value|
      average[key] = value / nb
    end
    
    point_time = PointTime.create(
      time: end_time - 4.hours
    )
    
    average.each do |key, value|
      point_data = PointData.create(
        inverter_id: key,
        point_time_id: point_time.id,
        value: value,
        unit: 'W'
      )
    end
    
    Month.create(
      point_time_id: point_time.id
    )
  end
end

class Day < ActiveRecord::Base
  belongs_to :point_times
  
  def self.compute_day
    now = DateTime.now
    end_time = DateTime.new(now.year, now.month, now.day, now.hour, now.minute)
    start_time = end_time - 15.minutes
    
    average = {}
    nb = 0
    
    inverters = Inverter.all
    inverters.each do |inverter|
      average[inverter.id] = 0.0
    end    
    
    times = PointTime.joins(:hours, :point_datas).where(time: start_time..end_time).includes(:hours, :point_datas)
    times.each do |time|
      time.point_datas.each do |data|
        average[data.inverter_id] = average[data.inverter_id] + data.value
      end
      nb = nb + 1
    end
    
    average.each do |key, value|
      average[key] = value / nb
    end
    
    # Store a new pointtime with pointdata and day
    minutes = end_time.minute
    if (minutes >= 45)
      minutes = 45
    elsif (minutes >= 30)
      minutes = 30
    elsif (minutes >= 15)
      minutes = 15
    else
      minutes = 0
    end
    
    point_time = PointTime.create(
      time: DateTime.new(end_time.year, end_time.month, end_time.day, end_time.hour, minutes)
    )
    
    average.each do |key, value|
      point_data = PointData.create(
        inverter_id: key,
        point_time_id: point_time.id,
        value: value,
        unit: 'W'
      )
    end
    
    Day.create(
      point_time_id: point_time.id
    )
  end
end

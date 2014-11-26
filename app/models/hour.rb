class Hour < ActiveRecord::Base
  belongs_to :point_time
  has_many :point_datas, through: :point_times
  
  def self.compute_hour
    inverters = Inverter.all
    values = {}
    
    inverters.each do |inverter|
      url = "http://#{inverter.user}:#{inverter.pass}@#{inverter.ip}/"
      response = RestClient.get url
      doc = Nokogiri::HTML(response.to_str)
      power = doc.css('td[bgcolor="#FFFFFF"]')[0]
      values[inverter.id] = power.children.last.text.to_f
    end
    
    now = DateTime.now
    point_time = PointTime.create(
      time: DateTime.new(now.year, now.month, now.day, now.hour, now.minute)
    )
    
    values.each do |key, value|
      point_data = PointData.create(
        inverter_id: key,
        point_time_id: point_time.id,
        value: value,
        unit: 'W'
      )
    end
    
    Hour.create(
      point_time_id: point_time.id
    )
  end
  
end

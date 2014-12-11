class Api::ValuesController < ApplicationController
  
  def json
    # Time instead datetime for range computation
    end_time = params[:end] ? Time.at(params[:end].to_f / 1000) : Time.now
    start_time = params[:start] ? Time.at(params[:start].to_f / 1000) : Time.new(2014, 12, 2, 12, 0) # first year point (in our database)
    
    graph_data = []
    statistics = []
    
    zones = Zone.all.includes(:inverters)
    zones.each do |zone|
      tab = []
      hash = {}
      zone.inverters.each do |inverter|
        computation(hash, start_time, end_time, inverter)
      end
      
      hash.sort.map do |key, value|
        tab.push([key, value.round(2)])
      end
      
      graph_data.push({name: zone.name, data: tab})
      
      max = hash.empty? ? 0.0 : hash.values.max
      min = hash.empty? ? 0.0 : hash.values.min
      average = hash.empty? ? 0.0 : hash.values.sum / hash.length
      
      statistics.push({name: zone.name, max: max.round(2), min: min.round(2), average: average.round(2)})
    end
    
    response = { data: graph_data, statistics: statistics }
    render json: response
  end
  
  def lastpoint
    response = []
    
    time = Hour.last.point_time
    zones = Zone.all.includes(:inverters)
    zones.each do |zone|
      tab = []
      value = 0
      zone.inverters.each do |inverter|
        value += time.point_datas.where(inverter_id: inverter.id).last.value
      end
      
      response.push({name: zone.name, data: [time.time.to_f * 1000, value.round(2)]})
    end
    
    render json: response
  end
  
  private
  
  def computation(hash, start_time, end_time, inverter)
    times = get_times start_time, end_time, inverter
    times.each do |t|
      value = 0
      if hash.has_key?((t.time.to_f * 1000).to_i)
        value = hash[(t.time.to_f * 1000).to_i]
      end
      
      t.point_datas.each do |data|
        value += data.value
      end
      
      hash[(t.time.to_f * 1000).to_i] = value  
    end
  end
  
  def get_times(start_time, end_time, inverter)
    range = end_time - start_time
    
    if range < 8.hours
      period = 'hours'
    elsif range < 1.week
      period = 'days'
    elsif range < 1.month
      period = 'weeks'
    elsif range < 1.year
      period = 'months'
    else
      period = 'years'
    end
    
    # Convert time to datetime for correct UTC queries
    start_date = DateTime.new(start_time.year, start_time.month, start_time.day, start_time.hour, start_time.min)
    end_date = DateTime.new(end_time.year, end_time.month, end_time.day, end_time.hour, end_time.min)
    
    PointTime.joins(period.to_sym, :point_datas).where(time: start_date..end_date, point_datas: { inverter_id: inverter.id }).includes(period.to_sym, :point_datas)
  end
  
end

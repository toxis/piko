class Api::ValuesController < ApplicationController
  
  def json
    now = DateTime.now
    end_time = DateTime.new(now.year, now.month, now.day, now.hour, now.minute)
    start_time = get_start_time(end_time)
    
    response = []
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
      
      response.push({name: zone.name, data: tab})
    end
    
    render json: response
  end
  
  def lastpoint
    #total = 0
    #time = Hour.last.point_time
    #if (params[:inverter] && params[:inverter].to_i > 0)
    #  total = time.point_datas.where(inverter_id: params[:inverter]).last.value
    #else
    #  time.point_datas.each do |data|
    #    total += data.value
    #  end
    #end
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
  
  def get_start_time(end_time)
    diff = 1.hour
    if params[:period]
      case params[:period]
      when 'daily'
        diff = 1.day
      when 'weekly'
        diff = 1.week
      when 'monthly'
        diff = 1.month
      when 'yearly'
        diff = 1.month
      end
    end
    end_time - diff
  end
  
  def computation(hash, start_time, end_time, inverter)
    times = get_times start_time, end_time, inverter #PointTime.includes(:hours, :point_datas).where(time: start_time..end_time, point_datas: { inverter_id: inverter.id })
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
    period = 'hours'
    if params[:period]
      case params[:period]
      when 'daily'
        period = 'days'
      when 'weekly'
        period = 'weeks'
      when 'monthly'
        period = 'months'
      when 'yearly'
        period = 'years'
      end
    end
    PointTime.joins(period.to_sym, :point_datas).where(time: start_time..end_time, point_datas: { inverter_id: inverter.id }).includes(period.to_sym, :point_datas)
  end
  
  def get_hourly_data
    now = DateTime.now
    end_time = DateTime.new(now.year, now.month, now.day, now.hour, now.minute)
    start_time = end_time - 1.hour
    
    times = PointTime.includes(:hours, :point_datas).where(time: start_time..end_time)
    if (params[:inverter] && params[:inverter].to_i > 0)
      times = times.where(point_datas: { inverter_id: params[:inverter] })
    end
    
    response = []
    times.each do |time|
      total = 0
      if time.hours.length == 1
        time.point_datas.each do |data|
          total += data.value
        end
        response.push([(time.time.to_f * 1000).to_i, total.round(2)])
      end
    end
    response
  end
  
  def get_daily_data
    now = DateTime.now
    end_time = DateTime.new(now.year, now.month, now.day, now.hour, now.minute)
    start_time = end_time - 1.day
    
    times = PointTime.includes(:days, :point_datas).where(time: start_time..end_time)
    if (params[:inverter] && params[:inverter].to_i > 0)
      times = times.where(point_datas: { inverter_id: params[:inverter] })
    end
    
    response = []
    times.each do |time|
      total = 0
      if time.days.length == 1
        time.point_datas.each do |data|
          total += data.value
        end
        response.push([(time.time.to_f * 1000).to_i, total.round(2)])
      end
    end
    response
  end
  
  
  
end

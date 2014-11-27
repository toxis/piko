# encoding: utf-8
class ValuesController < ApplicationController
  
  def index
    @inverters = Inverter.all
    @zones = Zone.all
    
    @title = "Puissance [W] estimée (moyenne)"
    period = params[:period] || 'hourly'
    @title = 'Puissance [W] mesurée' if period == 'hourly'
    
    @json_params = {}
    @json_params[:period] = params[:period] if params[:period]
  end
  
  def week
    Week.compute_week
    render text: 'Week computed'
  end
  
  def month
    Month.compute_month
    render text: 'Month computed'
  end
  
end

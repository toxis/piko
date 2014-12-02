# encoding: utf-8
class ValuesController < ApplicationController
  
  def index
    params[:period] ||= 'hourly'
    @inverters = Inverter.all
    @zones = Zone.all
    
    @title = "Puissance [W] estimée (moyenne)"
    @title = 'Puissance [W] mesurée' if params[:period] == 'hourly'
    
    @json_params = {}
    @json_params[:period] = params[:period]
  end
  
  # Debug actions (only available in development environment)
  def week
    Week.compute_week
    render text: 'Week computed'
  end
  
  def month
    Month.compute_month
    render text: 'Month computed'
  end
  
  def year
    Year.compute_year
    render text: 'Year computed'
  end
  
end

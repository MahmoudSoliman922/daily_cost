# frozen_string_literal: true

# helper methods for the step definations of the daily cost feature
module DailyCost
  def daily_costs
    @daily_costs ||= {}
  end

  def add_start_date(date)
    daily_costs[:start_date] = date
  end

  def add_end_date(date)
    daily_costs[:end_date] = date
  end

  def add_time_interval(time_period_costs)
    daily_costs[:time_period_costs] ||= []
    daily_costs[:time_period_costs] = time_period_costs
  end

  def call
    LifeTimely.daily_cost(daily_costs[:start_date], daily_costs[:end_date], daily_costs[:time_period_costs])
  end
end

World(DailyCost)

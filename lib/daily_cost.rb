# frozen_string_literal: true

require 'daily_cost_calculator'

# lifetimely module for calculating daily cost
module LifeTimely
  def self.daily_cost(start_date, end_date, time_period_costs)
    time_periods_group = {
      daily: 0,
      weekly: 0,
      monthly: 0
    }

    time_periods_group = DailyCostCalculator.group_cost_by_time_period(time_period_costs, time_periods_group)
    DailyCostCalculator.create_daily_costs(start_date, end_date, time_periods_group)
  end
end

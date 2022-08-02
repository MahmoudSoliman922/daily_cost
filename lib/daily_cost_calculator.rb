# frozen_string_literal: true

require_relative '../helpers/date_helpers'

# module that helps calculating the daily cost in a clean approach
module DailyCostCalculator
  def self.group_cost_by_time_period(time_periods_with_costs, time_periods_group)
    time_periods_with_costs.each do |time_period_with_cost|
      time_period_instance = time_periods_group[time_period_with_cost[:time_period].to_sym]
      raise StandardError, 'invalid time period' if time_period_instance.nil?
      raise StandardError, 'invalid cost' unless time_period_with_cost[:cost].is_a? Float
      raise StandardError, 'cost should be a positive decimal' if time_period_with_cost[:cost].negative?

      time_periods_group[time_period_with_cost[:time_period].to_sym] += time_period_with_cost[:cost]
    end
    time_periods_group
  end

  # rubocop:disable Metrics/MethodLength
  def self.create_daily_costs(start_date, end_date, time_periods_group)
    raise StandardError, 'invalid start date' unless start_date.is_a? Date
    raise StandardError, 'invalid end date' unless end_date.is_a? Date
    raise StandardError, 'start date must be eariler than the end date' if start_date > end_date

    res = []
    start_date.upto(end_date) do |date|
      res.push({
                 date: date.strftime('%a, %d %b %Y'),
                 cost: calculate_total_cost_per_date(time_periods_group[:daily],
                                                     time_periods_group[:weekly],
                                                     time_periods_group[:monthly],
                                                     date)
               })
    end
    res
  end
  # rubocop:enable Metrics/MethodLength

  def self.calculate_total_cost_per_date(daily, weekly, monthly, current_month)
    calculate_cost_per_day(daily, 1) +
      calculate_cost_per_day(weekly, 7) +
      calculate_cost_per_day(monthly, DateHelpers.days_in_a_month(current_month.month, current_month.year))
  end

  def self.calculate_cost_per_day(cost, number_of_days)
    cost / number_of_days
  end

  private_class_method :calculate_cost_per_day, :calculate_total_cost_per_date
end

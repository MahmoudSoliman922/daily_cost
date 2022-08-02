# frozen_string_literal: true

# Date helpers that is not supported in the Date class
class DateHelpers
  def self.days_in_a_month(month, year)
    Date.new(year, month, -1).day
  end
end

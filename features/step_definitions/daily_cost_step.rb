# frozen_string_literal: true

require 'date'

When('sending a valid time period') do
  add_start_date(Date.new(2019, 10, 1))
  add_end_date(Date.new(2019, 10, 3))
end

When('a list of time interval and cost pairs') do
  add_time_interval([
                      { time_period: 'daily', cost: 10.0 },
                      { time_period: 'weekly', cost: 70.0 }
                    ])
end

Then('should get a list of daily costs') do
  expect(call).to include({ date: Date.new(2019, 10, 1).strftime('%a, %d %b %Y'), cost: 20.0 })
  expect(call).to include({ date: Date.new(2019, 10, 2).strftime('%a, %d %b %Y'), cost: 20.0 })
  expect(call).to include({ date: Date.new(2019, 10, 3).strftime('%a, %d %b %Y'), cost: 20.0 })
end

When('sending an invalid start date') do
  add_start_date('invalid date')
  add_end_date(Date.new(2019, 10, 3))
end

Then('should get an error saying {string}') do |error|
  expect { call }.to raise_exception(StandardError, error)
end

When('sending an invalid end date') do
  add_start_date(Date.new(2019, 10, 1))
  add_end_date('invalid date')
end

When('a list of time interval and invalid cost pairs') do
  add_time_interval([
                      { time_period: 'daily', cost: 'invalid cost' }
                    ])
end

When('a list of time interval and negative cost pairs') do
  add_time_interval([
                      { time_period: 'daily', cost: -1.6 }
                    ])
end

When('sending an earlier end date') do
  add_end_date(Date.new(2019, 10, 1))
  add_start_date(Date.new(2019, 10, 3))
end

When('a list of invalid time interval and cost pairs') do
  add_time_interval([
                      { time_period: 'invalid time period', cost: 10 }
                    ])
end

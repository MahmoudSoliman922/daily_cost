# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength

require 'spec_helper'
require 'daily_cost_calculator'
require 'date'

describe DailyCostCalculator do
  let(:start_date) { Date.new(2019, 10, 1) }
  let(:end_date) { Date.new(2019, 10, 3) }
  let(:random_date) { Date.new(2020, 2, 2) }
  let(:time_period_with_costs) do
    [
      { time_period: 'daily', cost: 10.0 },
      { time_period: 'weekly', cost: 70.0 }
    ]
  end
  let(:time_periods_group) do
    {
      daily: 0,
      weekly: 0,
      monthly: 0
    }
  end

  context 'group_cost_by_time_period' do
    subject { described_class.group_cost_by_time_period(time_period_with_costs, time_periods_group) }

    describe 'when passing valid arguments' do
      it 'returns the updated time_periods_group' do
        expect(subject[:daily]).to eq(10.0)
        expect(subject[:weekly]).to eq(70.0)
        expect(subject[:monthly]).to eq(0)
      end
    end

    describe 'when passing invalid time period' do
      it 'raises an exception with message "invalid time period"' do
        time_period_with_costs.push({ time_period: 'invalid', cost: 10.0 })
        expect { subject }.to raise_exception(StandardError, 'invalid time period')
      end
    end

    describe 'when passing invalid cost' do
      it 'raises an exception with message "invalid cost"' do
        time_period_with_costs.push({ time_period: 'daily', cost: 'string' })
        expect { subject }.to raise_exception(StandardError, 'invalid cost')
      end
    end

    describe 'when passing negative cost' do
      it 'raises an exception with message "cost should be a positive decimal"' do
        time_period_with_costs.push({ time_period: 'daily', cost: -1.6 })
        expect { subject }.to raise_exception(StandardError, 'cost should be a positive decimal')
      end
    end
  end

  context 'calculate_cost_per_day' do
    subject { described_class.send(:calculate_cost_per_day, 100.0, 30) }

    describe 'when passing valid arguments' do
      it 'returns the devision of the cost over the number of days' do
        expect(subject).to eq(100.0 / 30)
      end
    end
  end

  context 'calculate_total_cost_per_date' do
    subject do
      described_class.send(:calculate_total_cost_per_date,
                           time_periods_group[:daily],
                           time_periods_group[:weekly],
                           time_periods_group[:monthly],
                           random_date)
    end

    describe 'when passing valid arguments' do
      it 'returns the devision of the cost over the number of days' do
        time_periods_group[:daily] = 10
        time_periods_group[:weekly] = 70
        time_periods_group[:monthly] = 290

        expect(subject).to eq(30)
      end
    end
  end

  context 'create_daily_costs' do
    subject { described_class.create_daily_costs(start_date, end_date, time_periods_group) }

    describe 'when passing valid arguments' do
      it 'returns the created daily costs' do
        expect(subject.size).to eq(3)
        start_date.upto(end_date) do |date|
          expect(subject).to include({ cost: 0, date: date.strftime('%a, %d %b %Y') })
        end
      end
    end

    describe 'when passing invalid start date' do
      let(:start_date) { 'invalid date' }

      it 'raises an exception with message "invalid start date"' do
        expect { subject }.to raise_exception(StandardError, 'invalid start date')
      end
    end

    describe 'when passing invalid end date' do
      let(:end_date) { 'invalid date' }

      it 'raises an exception with message "invalid end date"' do
        expect { subject }.to raise_exception(StandardError, 'invalid end date')
      end
    end

    describe 'when providing an end date earlier than the start date' do
      let(:end_date) { Date.new(2019, 10, 1) }
      let(:start_date) { Date.new(2019, 10, 3) }

      it 'raises an exception with message "start date must be eariler than the end date"' do
        expect { subject }.to raise_exception(StandardError, 'start date must be eariler than the end date')
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength

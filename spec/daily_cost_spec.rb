# frozen_string_literal: true

require 'spec_helper'
require 'daily_cost'
require 'date'

describe LifeTimely do
  let(:start_date) { Date.new(2019, 10, 1) }
  let(:end_date) { Date.new(2019, 10, 3) }
  let(:time_period_with_costs) do
    [
      { time_period: 'daily', cost: 10.0 },
      { time_period: 'weekly', cost: 70.0 }
    ]
  end
  subject { described_class.daily_cost(start_date, end_date, time_period_with_costs) }
  context 'daily_cost' do
    describe 'when passing valid arguments' do
      it 'returns a list of daily costs for each day from the start to end date' do
        expect(subject.size).to eq(3)
        start_date.upto(end_date) do |date|
          expect(subject).to include({ cost: 20, date: date.strftime('%a, %d %b %Y') })
        end
      end
    end
  end
end

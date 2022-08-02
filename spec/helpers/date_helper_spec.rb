# frozen_string_literal: true

require 'spec_helper'
require_relative '../../helpers/date_helpers'
require 'date'

describe DateHelpers do
  let(:random_date) { Date.new(2019, 10, 1) }

  subject { described_class.days_in_a_month(random_date.month, random_date.year) }
  context 'daily_cost' do
    describe 'when passing valid arguments' do
      it 'returns the number of days in that month' do
        expect(subject).to eq(31)
      end
    end
  end
end

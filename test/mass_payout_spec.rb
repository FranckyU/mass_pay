# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/mass_pay'

describe MassPay do
  before do
    load_test_data
  end

  it 'should return empty result when fed empty payments collection' do
    expect(
      MassPay
        .group_payouts(@test_matrix[:empty][:input], @test_matrix[:empty][:group_size])
    ).must_be_empty # eq. see expectation: []
  end

  it 'should return grouped payouts' do
    expect(
      MassPay
        .group_payouts(@test_matrix[:with_data][:input], @test_matrix[:with_data][:group_size])
    ).must_equal(@test_matrix[:with_data][:expectation])
  end

  it 'should return limit to 1 payout per day for N payouts on same recipient' do
    expect(
      MassPay
        .group_payouts(@test_matrix[:same_recipient][:input], @test_matrix[:same_recipient][:group_size])
    ).must_equal(@test_matrix[:same_recipient][:expectation])
  end

  it 'should split payouts evenly - EXTRA spec, might not be necessary' do
    expect(
      MassPay
        .group_payouts(@test_matrix[:even_payouts][:input], @test_matrix[:even_payouts][:group_size])
    ).must_equal(@test_matrix[:even_payouts][:expectation])
  end

  def load_test_data
    @test_matrix = {
      empty: {
        group_size: 250,
        input: [],
        expectation: []
      },
      with_data: {
        group_size: 250,
        input: [
          { email: 'bob@example.com', amount: 400 },
          { email: 'susan@example.com', amount: 8000 },
          { email: 'bob@example.com', amount: 400 },
          { email: 'alan@example.com', amount: 300 },
          { email: 'alan@example.com', amount: 12 },
          { email: 'dana@example.com', amount: 675 }
        ],
        expectation: [
          [
            { email: 'bob@example.com', amount: 400 },
            { email: 'susan@example.com', amount: 8000 },
            { email: 'alan@example.com', amount: 300 },
            { email: 'dana@example.com', amount: 675 }
          ],
          [
            { email: 'bob@example.com', amount: 400 },
            { email: 'alan@example.com', amount: 12 }
          ]
        ]
      },
      same_recipient: {
        group_size: 250,
        input: [
          { email: 'bob@example.com', amount: 400 },
          { email: 'bob@example.com', amount: 8000 },
          { email: 'bob@example.com', amount: 300 }
        ],
        expectation: [
          [
            { email: 'bob@example.com', amount: 400 }
          ],
          [
            { email: 'bob@example.com', amount: 8000 }
          ],
          [
            { email: 'bob@example.com', amount: 300 }
          ]
        ]
      },
      even_payouts: {
        group_size: 3,
        input: [
          { email: 'bob@example.com', amount: 400 },
          { email: 'susan@example.com', amount: 8000 },
          { email: 'bob@example.com', amount: 400 },
          { email: 'alan@example.com', amount: 300 },
          { email: 'alice@example.com', amount: 400 },
          { email: 'alice@example.com', amount: 100 },
          { email: 'dana@example.com', amount: 675 },
          { email: 'carl@example.com', amount: 100 }
        ],
        expectation: [
          [
            { email: 'bob@example.com', amount: 400 },
            { email: 'susan@example.com', amount: 8000 },
            { email: 'alan@example.com', amount: 300 }
          ],
          [
            { email: 'alice@example.com', amount: 400 },
            { email: 'dana@example.com', amount: 675 },
            { email: 'carl@example.com', amount: 100 }
          ],
          [
            { email: 'bob@example.com', amount: 400 },
            { email: 'alice@example.com', amount: 100 }
          ]
        ]
      }
    }
  end
end

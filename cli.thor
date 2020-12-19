# frozen_string_literal: true

require 'pp'
require_relative 'lib/mass_pay'

## Main entry for the CLI
# Runs MassPay with the sample data
class Run < Thor
  desc 'Mass Pay', 'groups payouts by recipient'
  def sample
    example = [
      { email: 'bob@example.com', amount: 400 },
      { email: 'susan@example.com', amount: 8000 },
      { email: 'bob@example.com', amount: 400 },
      { email: 'alan@example.com', amount: 300 },
      { email: 'alan@example.com', amount: 12 },
      { email: 'dana@example.com', amount: 675 }
    ]

    pp MassPay.group_payouts(example)
  end
end

# frozen_string_literal: true

## Provides payouts grouping by recipient email
# 1. Main entry method `group_payouts`
# 2. Accepts an array of payouts
# 3. Accepts a variable group size - default 250
# 4. Evenly distribute payouts so recipients after a long string of a same recipient payouts are not penalized
module MassPay
  module_function

  def group_payouts(payouts, max_group_size = 250)
    group_payouts_by_recipient(payouts, max_group_size)
  end

  private_class_method def group_payouts_by_recipient(payouts, max_group_size, grouped = [])
    batch = []
    next_round_batch = []
    emails = {}

    batch_size = [payouts.size, max_group_size].min
    counter = 0

    until counter == batch_size
      item = payouts.shift

      break if item.nil?

      if emails.key?(item[:email])
        next_round_batch << item
      else
        batch << item
        emails[item[:email]] = true
        counter += 1
      end
    end

    next_round_batch = (payouts.any? && (payouts + next_round_batch)) || next_round_batch

    grouped << batch unless batch.empty?
    grouped = group_payouts_by_recipient(next_round_batch, max_group_size, grouped) if next_round_batch.any?
    grouped
  end
end

module Gateways::Stripe::Features
  module Charge
    extend ActiveSupport::Concern

    def charge(payload, &block)
      source_or_ref =
        payload.credit_card_token.present? ?
          { source: payload.credit_card_token } :
          { customer: payload.credit_card_ref }

      charge = ::Stripe::Charge.create(
        {
          amount: payload.amount_to_cents,
          currency: payload.currency,
          capture: !payload.authorization
        }.merge(source_or_ref),
        api_key: api_keys[:secret_key],
      )

      block.call(charge.id) if block
    rescue Exception => e
      block.call(nil, e.message) if block
    end
  end
end

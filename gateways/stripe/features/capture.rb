module Gateways::Stripe::Features
  module Capture
    extend ActiveSupport::Concern

    def capture(payload, &block)
      capture = ::Stripe::Charge.capture(
        payload.payment.gateway_ref,
        {
          amount: payload.amount_to_cents
        },
        api_key: api_keys[:secret_key]
      )
      block.call(capture.id) if block
    rescue Exception => e
      block.call(nil, e.message) if block
    end
  end
end

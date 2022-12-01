module Gateways::Stripe::Features
  module Refund
    extend ActiveSupport::Concern

    def refund(payload, &block)
      refund = ::Stripe::Refund.create({
        charge: payload.payment.gateway_ref,
      }, api_key: api_keys[:secret_key])

      block.call(refund.id) if block
    rescue Exception => e
      block.call(nil, e.message) if block
    end
  end
end

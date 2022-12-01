
module Gateways::Stripe::Features
  module HandleResponse
    extend ActiveSupport::Concern

    def handle_response(payload, &block)
      session = Stripe::Checkout::Session.retrieve(payload["gateway_ref"],
        api_key: api_keys[:secret_key]
      )
      pi_ref = session.payment_intent

      pi = Stripe::PaymentIntent.retrieve(pi_ref,
        api_key: api_keys[:secret_key]
      )

      success, message = if pi.status == "succeeded"    
                           [true]
                         else
                           [false, "Unknown issue, please contact customer services"]
                         end

      block.call(success, nil, message) if block
    end
  end
end

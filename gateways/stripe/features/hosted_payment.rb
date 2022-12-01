module Gateways::Stripe::Features
  module HostedPayment
    extend ActiveSupport::Concern

    def gateway_redirection_content(payload, &block)
      gateway_ref = get_gateway_ref(payload)
      block.call(gateway_ref) if block

      content = <<-CONTENT
<script src="https://js.stripe.com/v3/"></script>
<script>
  var stripe = Stripe("#{api_keys[:publishable_key]}");

  stripe.redirectToCheckout({sessionId: "#{gateway_ref}"});
</script>
CONTENT
      redirection_template_base(content)
    end

    private

    def get_gateway_ref(payload)
      request_params ||= {
        success_url: payload.gateway_callback_url,
        cancel_url: payload.gateway_callback_url,
        payment_method_types: ["card"],
        line_items: [{
          name: payload.company_product_name,
          description: payload.company_name,
          amount: payload.amount_to_cents,
          currency: payload.currency,
          quantity: 1,
        }],
      }

      ::Stripe::Checkout::Session.create(
        request_params,
        api_key: api_keys[:secret_key],
      ).id
    rescue Exception => e
      e.message
    end
  end
end

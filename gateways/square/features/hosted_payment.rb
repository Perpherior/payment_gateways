module Gateways::Square::Features
  module HostedPayment
    extend ActiveSupport::Concern
    include Helpers

    included do
      def gateway_redirection_content(payload, &block)
        checkout = generate_redirection_url(payload).checkout

        block.call(checkout[:order][:id]) if block

        url = checkout[:checkout_page_url]

        content = <<-CONTENT
<script>
  window.location = "#{url}"
</script>
CONTENT
        redirection_template_base(content)
      end
    end

    private

    def generate_redirection_url(payload)
      checkout_api = client.checkout
      body = {
        idempotency_key: payload.id,
        redirect_url: payload.gateway_callback_url,
        order: {
          order: {
            location_id: location_id,
            line_items: [
              {
                base_price_money: {
                  amount: payload.amount_to_cents,
                  currency: payload.currency&.upcase || "GBP"
                },
                name: payload.company_product_name,
                quantity: "1"
              },
            ],
          }
        }
      }

      result = checkout_api.create_checkout(location_id: location_id, body: body)

      if result.success?
        result.data
      elsif result.error?
        puts result.errors
        result.errors
      end
    end
  end
end

module Gateways::Stripe::Features
  module SaveCard
    extend ActiveSupport::Concern

    def save_card(source, &block)
      customer = ::Stripe::Customer.create(
        {
          source: source,
        },
        api_key: api_keys[:secret_key],
      )
    
      block.call(customer.id) if block
    rescue Exception => e
      block.call(nil, e.message) if block
    end
  end
end

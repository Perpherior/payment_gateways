
module Gateways::Square::Features
  module HandleResponse
    extend ActiveSupport::Concern
    include Helpers

    def handle_response(params, &block)
      if params[:transactionId].nil?
        raise SecurityError, "Invalid Request"
      end

      orders_api = client.orders

      order_id = params[:transactionId]

      result = orders_api.retrieve_order(order_id: order_id)

      success, message = if result.success? && result.data.order[:state]&.downcase == "completed"
                           [true]
                         elsif result.error?
                           [false, result.errors.collect { |r| r[:detail] }.join(", ")]
                         end

      block.call(success, nil, message) if block
    end
  end
end

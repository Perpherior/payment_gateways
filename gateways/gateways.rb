module Gateways
  ADAPTERS = [
    ::Gateways::Anz::Adapter,
    ::Gateways::Stripe::Adapter,
    ::Gateways::Square::Adapter,
  ]

  def self.find_adapter_by_name(name)
    ("Gateways::" + name.camelize + "::Adapter").constantize
  end

  def self.adapter_by_payment(payment)
    find_adapter_by_name(payment.gateway).new(payment.api_keys)
  rescue
    nil
  end
end

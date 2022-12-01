class Gateways::Stripe::Adapter
  include Gateways::Base
  include Gateways::Stripe::Features::HostedPayment
  include Gateways::Stripe::Features::Refund
  include Gateways::Stripe::Features::Charge
  include Gateways::Stripe::Features::Capture
  include Gateways::Stripe::Features::SaveCard
  include Gateways::Stripe::Features::HandleResponse

  NAME = "stripe"
  DOC_LINK = "https://stripe.com/docs"
  API_KEY_NOTES = {
    publishable_key: "On the client-side.Can be publicly-accessible in your web or mobile app’s client-side code (such as checkout.js) to tokenize payment information such as with Stripe Elements. By default, Stripe Checkout tokenizes payment information.",
    secret_key: "On the server-side. Must be secret and stored securely in your web or mobile app’s server-side code (such as in an environment variable or credential management system) to call Stripe APIs.",
  }
  CURRENCIES = [
    "hkd",
    "usd",
  ]

  def self.payment_methods
    [
      :direct,
      :hosted,
    ]
  end

  def self.api_keys
    [:publishable_key, :secret_key]
  end

  def self.support_authorization?
    true
  end
end

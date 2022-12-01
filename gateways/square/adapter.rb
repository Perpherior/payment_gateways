class Gateways::Square::Adapter
  include Gateways::Base
  include Gateways::Square::Features::HostedPayment
  include Gateways::Square::Features::HandleResponse

  NAME = "square"
  DOC_LINK = "https://developer.squareup.com"
  API_KEY_NOTES = {
    access_token: "The Personal Access Token grants full API access to your Square account. Never share it with anyone, including Square employees.",
    location_id: "The ID of the original payment's associated location.",
    environment: "Environment. Sanbox or production.",
  }
  CURRENCIES = [
    "usd",
    "aud",
    "cad",
    "jpy",
    "eur",
    "gbp",
  ]

  def self.payment_methods
    [
      :hosted,
    ]
  end

  def self.api_keys
    [:access_token, :location_id, :environment]
  end
end

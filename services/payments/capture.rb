class Payments::Capture
  include ActiveModel::Model

  attr_accessor :company,
                :id,
                :amount

  validates :company, :id, :payment, presence: true

  def call
    return false unless valid?
    process_capture
    if payment.succeeded?
      payment
    else
      false
    end
  end

  def process_capture
    gateway_adapter.new(payment.api_keys).capture(self) do |id, error_message|
      if id.present?
        payment.capture!(capture_amount)
      end
    end
  end

  def gateway_adapter
    Gateways.find_adapter_by_name(payment.gateway)
  end

  def payment
    @payment ||= company.payments.authorized.pending.find_by(id: id)
  end

  def amount_to_cents
    (capture_amount.to_f.round(2) * 100).to_i
  end

  def capture_amount
    amount || payment.amount
  end
end

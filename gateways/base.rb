module Gateways::Base
  extend ActiveSupport::Concern

  included do
    self.initialize! if self.respond_to?(:initialize!)

    attr_reader :api_keys
  end

  def initialize(api_keys)
    @api_keys = api_keys.symbolize_keys
  end

  def charge(payload)
    raise NotImplementedError
  end

  def refund(payload)
    raise NotImplementedError
  end

  def save_card(source)
    raise NotImplementedError
  end

  def handle_response(params)
    raise NotImplementedError
  end

  def gateway_redirection_content(payload)
    raise NotImplementedError
  end

  private

  def redirection_template_base(content)
    <<-CONTENT
<html>
<body><h2>Processing...</h2></body>
#{content}
</html>
CONTENT
  end

  def idempotency_key(token)
    "#{token}-#{Time.current.strftime("%d%m%y")}"
  end

  def strfparam(request_params)
    CGI.unescape(URI.encode_www_form(request_params))
  end

  module ClassMethods
    def adapter_name
      self::NAME
    end

    def payment_methods
      []
    end

    def support_authorization?
      false
    end
  end
end

module Gateways::Square::Features
  module Helpers
    extend ActiveSupport::Concern
    
    def client
      return @client if defined? @client
      @client = Square::Client.new(
        access_token: access_token,
        environment: environment || 'production'
      )
    end

    def access_token
      api_keys[:access_token]
    end

    def location_id
      api_keys[:location_id]
    end

    def environment
      api_keys[:environment]
    end
  end
end

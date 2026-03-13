# frozen_string_literal: true

require 'faraday'

module Legion
  module Extensions
    module Twilio
      module Helpers
        module Client
          BASE_URL = 'https://api.twilio.com/2010-04-01'

          def connection(account_sid: nil, auth_token: nil, **_opts)
            Faraday.new(url: BASE_URL) do |conn|
              conn.request :json
              conn.request :authorization, :basic, account_sid, auth_token
              conn.response :json, content_type: /\bjson$/
              conn.headers['Accept'] = 'application/json'
            end
          end
        end
      end
    end
  end
end

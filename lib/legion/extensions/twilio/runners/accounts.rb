# frozen_string_literal: true

require 'legion/extensions/twilio/helpers/client'

module Legion
  module Extensions
    module Twilio
      module Runners
        module Accounts
          include Legion::Extensions::Twilio::Helpers::Client

          def get_account(account_sid: nil, **)
            response = connection(account_sid: account_sid, **).get(
              "/Accounts/#{account_sid}.json"
            )
            { result: response.body }
          end

          def list_accounts(friendly_name: nil, status: nil, page_size: 50, page: 0, account_sid: nil, **)
            params = { 'PageSize' => page_size, 'Page' => page }
            params['FriendlyName'] = friendly_name if friendly_name
            params['Status'] = status if status

            response = connection(account_sid: account_sid, **).get('/Accounts.json', params)
            { result: response.body }
          end

          def update_account(friendly_name: nil, status: nil, account_sid: nil, **)
            payload = {}
            payload['FriendlyName'] = friendly_name if friendly_name
            payload['Status'] = status if status

            response = connection(account_sid: account_sid, **).post(
              "/Accounts/#{account_sid}.json", payload
            )
            { result: response.body }
          end

          include Legion::Extensions::Helpers::Lex if Legion::Extensions.const_defined?(:Helpers) &&
                                                      Legion::Extensions::Helpers.const_defined?(:Lex)
        end
      end
    end
  end
end

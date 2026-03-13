# frozen_string_literal: true

require 'legion/extensions/twilio/helpers/client'

module Legion
  module Extensions
    module Twilio
      module Runners
        module Calls
          include Legion::Extensions::Twilio::Helpers::Client

          def create_call(to:, from:, url: nil, twiml: nil, status_callback: nil,
                          status_callback_event: nil, record: nil, account_sid: nil, **)
            payload = { 'To' => to, 'From' => from }
            payload['Url'] = url if url
            payload['Twiml'] = twiml if twiml
            payload['StatusCallback'] = status_callback if status_callback
            payload['StatusCallbackEvent'] = status_callback_event if status_callback_event
            payload['Record'] = record unless record.nil?

            response = connection(account_sid: account_sid, **).post(
              "/Accounts/#{account_sid}/Calls.json", payload
            )
            { result: response.body }
          end

          def get_call(call_sid:, account_sid: nil, **)
            response = connection(account_sid: account_sid, **).get(
              "/Accounts/#{account_sid}/Calls/#{call_sid}.json"
            )
            { result: response.body }
          end

          def list_calls(account_sid: nil, status: nil, from: nil, to: nil,
                         start_time: nil, end_time: nil, page_size: 50, page: 0, **)
            params = { 'PageSize' => page_size, 'Page' => page }
            params['Status'] = status if status
            params['From'] = from if from
            params['To'] = to if to
            params['StartTime'] = start_time if start_time
            params['EndTime'] = end_time if end_time

            response = connection(account_sid: account_sid, **).get(
              "/Accounts/#{account_sid}/Calls.json", params
            )
            { result: response.body }
          end

          def update_call(call_sid:, account_sid: nil, url: nil, twiml: nil, status: nil, **)
            payload = {}
            payload['Url'] = url if url
            payload['Twiml'] = twiml if twiml
            payload['Status'] = status if status

            response = connection(account_sid: account_sid, **).post(
              "/Accounts/#{account_sid}/Calls/#{call_sid}.json", payload
            )
            { result: response.body }
          end

          def delete_call(call_sid:, account_sid: nil, **)
            response = connection(account_sid: account_sid, **).delete(
              "/Accounts/#{account_sid}/Calls/#{call_sid}.json"
            )
            { result: response.status == 204 }
          end

          include Legion::Extensions::Helpers::Lex if Legion::Extensions.const_defined?(:Helpers) &&
                                                      Legion::Extensions::Helpers.const_defined?(:Lex)
        end
      end
    end
  end
end

# frozen_string_literal: true

require 'legion/extensions/twilio/helpers/client'

module Legion
  module Extensions
    module Twilio
      module Runners
        module Messages
          include Legion::Extensions::Twilio::Helpers::Client

          def send_message(to:, from: nil, body: nil, messaging_service_sid: nil,
                           media_url: nil, status_callback: nil, account_sid: nil, **)
            payload = { 'To' => to, 'Body' => body }
            payload['From'] = from if from
            payload['MessagingServiceSid'] = messaging_service_sid if messaging_service_sid
            payload['MediaUrl'] = media_url if media_url
            payload['StatusCallback'] = status_callback if status_callback

            response = connection(account_sid: account_sid, **).post(
              "/Accounts/#{account_sid}/Messages.json", payload
            )
            { result: response.body }
          end

          def get_message(message_sid:, account_sid: nil, **)
            response = connection(account_sid: account_sid, **).get(
              "/Accounts/#{account_sid}/Messages/#{message_sid}.json"
            )
            { result: response.body }
          end

          def list_messages(account_sid: nil, date_sent: nil, from: nil, to: nil, page_size: 50, page: 0, **)
            params = { 'PageSize' => page_size, 'Page' => page }
            params['DateSent'] = date_sent if date_sent
            params['From'] = from if from
            params['To'] = to if to

            response = connection(account_sid: account_sid, **).get(
              "/Accounts/#{account_sid}/Messages.json", params
            )
            { result: response.body }
          end

          def redact_message(message_sid:, account_sid: nil, **)
            response = connection(account_sid: account_sid, **).post(
              "/Accounts/#{account_sid}/Messages/#{message_sid}.json", { 'Body' => '' }
            )
            { result: response.body }
          end

          def delete_message(message_sid:, account_sid: nil, **)
            response = connection(account_sid: account_sid, **).delete(
              "/Accounts/#{account_sid}/Messages/#{message_sid}.json"
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

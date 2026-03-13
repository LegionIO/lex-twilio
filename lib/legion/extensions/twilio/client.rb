# frozen_string_literal: true

require 'legion/extensions/twilio/helpers/client'
require 'legion/extensions/twilio/runners/messages'
require 'legion/extensions/twilio/runners/calls'
require 'legion/extensions/twilio/runners/accounts'

module Legion
  module Extensions
    module Twilio
      class Client
        include Helpers::Client
        include Runners::Messages
        include Runners::Calls
        include Runners::Accounts

        attr_reader :opts

        def initialize(account_sid:, auth_token:, **extra)
          @opts = { account_sid: account_sid, auth_token: auth_token, **extra }
        end

        def connection(**override)
          super(**@opts.merge(override))
        end
      end
    end
  end
end

# frozen_string_literal: true

require 'legion/extensions/twilio/version'
require 'legion/extensions/twilio/helpers/client'
require 'legion/extensions/twilio/runners/messages'
require 'legion/extensions/twilio/runners/calls'
require 'legion/extensions/twilio/runners/accounts'
require 'legion/extensions/twilio/client'

module Legion
  module Extensions
    module Twilio
      extend Legion::Extensions::Core if Legion::Extensions.const_defined? :Core
    end
  end
end

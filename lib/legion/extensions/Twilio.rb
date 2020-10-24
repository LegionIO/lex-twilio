require 'legion/extensions/twilio/version'

module Legion
  module Extensions
    module Twilio
      extend Legion::Extensions::Core if Legion::Extensions.const_defined? :Core
    end
  end
end

# lex-twilio

Twilio communications integration for [LegionIO](https://github.com/LegionIO/LegionIO). Send SMS/MMS messages, make voice calls, and manage accounts via the Twilio REST API.

## Installation

```bash
gem install lex-twilio
```

## Standalone Usage

```ruby
require 'legion/extensions/twilio/client'

client = Legion::Extensions::Twilio::Client.new(
  account_sid: 'ACxxxxx',
  auth_token: 'your_auth_token'
)

# Send an SMS
client.send_message(to: '+15551234567', from: '+15559876543', body: 'Hello!')

# Make a call
client.create_call(to: '+15551234567', from: '+15559876543', url: 'https://example.com/twiml')

# List recent messages
client.list_messages(page_size: 10)

# Get account info
client.get_account
```

## API Coverage

| Runner | Methods |
|--------|---------|
| Messages | `send_message`, `get_message`, `list_messages`, `redact_message`, `delete_message` |
| Calls | `create_call`, `get_call`, `list_calls`, `update_call`, `delete_call` |
| Accounts | `get_account`, `list_accounts`, `update_account` |

## Requirements

- Ruby >= 3.4
- [LegionIO](https://github.com/LegionIO/LegionIO) framework (optional for standalone client)
- Twilio account (Account SID + Auth Token)

## License

MIT

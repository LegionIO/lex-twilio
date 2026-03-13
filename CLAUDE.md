# lex-twilio: Twilio Integration for LegionIO

**Repository Level 3 Documentation**
- **Parent**: `/Users/miverso2/rubymine/legion/extensions-other/CLAUDE.md`
- **Grandparent**: `/Users/miverso2/rubymine/legion/CLAUDE.md`

## Purpose

Legion Extension that connects LegionIO to the Twilio communications platform. Provides runners for sending SMS/MMS messages, making voice calls, and managing Twilio accounts via the Twilio REST API (Basic Auth with Account SID + Auth Token).

**GitHub**: https://github.com/LegionIO/lex-twilio
**License**: MIT

## Architecture

```
Legion::Extensions::Twilio
├── Runners/
│   ├── Messages          # Send, list, get, redact, delete SMS/MMS
│   ├── Calls             # Create, list, get, update, delete voice calls
│   └── Accounts          # Get, list, update Twilio accounts
├── Helpers/
│   └── Client            # Faraday connection builder (Twilio REST API, Basic Auth)
└── Client                # Standalone client class (includes all runners)
```

## Key Files

| Path | Purpose |
|------|---------|
| `lib/legion/extensions/twilio.rb` | Entry point, loads all runners |
| `lib/legion/extensions/twilio/client.rb` | Standalone client (initialize with account_sid:, auth_token:) |
| `lib/legion/extensions/twilio/helpers/client.rb` | Faraday builder (Basic Auth: account_sid:auth_token) |
| `lib/legion/extensions/twilio/runners/` | Messages, Calls, Accounts |

## API Coverage

| Runner | Methods |
|--------|---------|
| Messages | `send_message`, `get_message`, `list_messages`, `redact_message`, `delete_message` |
| Calls | `create_call`, `get_call`, `list_calls`, `update_call`, `delete_call` |
| Accounts | `get_account`, `list_accounts`, `update_account` |

## Standalone Usage

```ruby
require 'legion/extensions/twilio/client'

client = Legion::Extensions::Twilio::Client.new(
  account_sid: 'ACxxxxx',
  auth_token: 'your_auth_token'
)

client.send_message(to: '+15551234567', from: '+15559876543', body: 'Hello from Legion!')
client.create_call(to: '+15551234567', from: '+15559876543', url: 'https://example.com/twiml')
```

## Dependencies

| Gem | Purpose |
|-----|---------|
| `faraday` (>= 2.0) | HTTP client for Twilio REST API |

## Development

```bash
bundle install
bundle exec rspec
bundle exec rubocop
```

---

**Maintained By**: Matthew Iverson (@Esity)

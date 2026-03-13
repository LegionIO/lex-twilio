# lex-twilio: Twilio Integration for LegionIO

**Repository Level 3 Documentation**
- **Category**: `/Users/miverso2/rubymine/legion/extensions/CLAUDE.md`

## Purpose

Legion Extension that connects LegionIO to the Twilio communications platform. Provides the foundation for sending SMS, making calls, and other Twilio operations from within Legion task chains.

**License**: MIT

## Architecture

```
Legion::Extensions::Twilio
└── (base extension with Twilio integration)
```

## Key Files

| Path | Purpose |
|------|---------|
| `lib/legion/extensions/Twilio.rb` | Entry point, extension registration |
| `lib/legion/extensions/Twilio/version.rb` | Version constant |

## Testing

```bash
bundle install
bundle exec rspec
bundle exec rubocop
```

---

**Maintained By**: Matthew Iverson (@Esity)

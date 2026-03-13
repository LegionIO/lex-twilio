# frozen_string_literal: true

RSpec.describe Legion::Extensions::Twilio::Client do
  let(:account_sid) { 'test_account_sid' }
  let(:auth_token) { 'test_auth_token' }
  let(:client) { described_class.new(account_sid: account_sid, auth_token: auth_token) }

  describe '#initialize' do
    it 'stores opts' do
      expect(client.opts).to include(account_sid: account_sid, auth_token: auth_token)
    end
  end

  describe '#connection' do
    it 'returns a Faraday connection' do
      expect(client.connection).to be_a(Faraday::Connection)
    end

    it 'uses the Twilio API base URL' do
      conn = client.connection
      expect(conn.url_prefix.to_s).to eq('https://api.twilio.com/2010-04-01')
    end
  end

  it 'includes Messages runner' do
    expect(client).to respond_to(:send_message)
    expect(client).to respond_to(:list_messages)
  end

  it 'includes Calls runner' do
    expect(client).to respond_to(:create_call)
    expect(client).to respond_to(:list_calls)
  end

  it 'includes Accounts runner' do
    expect(client).to respond_to(:get_account)
    expect(client).to respond_to(:list_accounts)
  end
end

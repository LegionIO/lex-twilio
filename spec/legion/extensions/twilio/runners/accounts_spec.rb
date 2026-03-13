# frozen_string_literal: true

RSpec.describe Legion::Extensions::Twilio::Runners::Accounts do
  let(:test_class) do
    Class.new do
      include Legion::Extensions::Twilio::Runners::Accounts
    end
  end
  let(:instance) { test_class.new }
  let(:account_sid) { 'test_account_sid' }
  let(:auth_token) { 'test_auth_token' }
  let(:connection) { instance_double(Faraday::Connection) }

  before do
    allow(instance).to receive(:connection).and_return(connection)
  end

  describe '#get_account' do
    it 'fetches account details' do
      response = instance_double(Faraday::Response, body: { 'sid' => account_sid, 'friendly_name' => 'My Account' })
      allow(connection).to receive(:get).and_return(response)

      result = instance.get_account(account_sid: account_sid, auth_token: auth_token)

      expect(connection).to have_received(:get).with("/Accounts/#{account_sid}.json")
      expect(result[:result]).to include('sid' => account_sid)
    end
  end

  describe '#list_accounts' do
    it 'lists accounts with default pagination' do
      response = instance_double(Faraday::Response, body: { 'accounts' => [{ 'sid' => account_sid }] })
      allow(connection).to receive(:get).and_return(response)

      result = instance.list_accounts(account_sid: account_sid, auth_token: auth_token)

      expect(connection).to have_received(:get).with(
        '/Accounts.json',
        hash_including('PageSize' => 50, 'Page' => 0)
      )
      expect(result[:result]).to have_key('accounts')
    end

    it 'filters by friendly name' do
      response = instance_double(Faraday::Response, body: { 'accounts' => [] })
      allow(connection).to receive(:get).and_return(response)

      instance.list_accounts(account_sid: account_sid, auth_token: auth_token, friendly_name: 'Test')

      expect(connection).to have_received(:get).with(
        '/Accounts.json',
        hash_including('FriendlyName' => 'Test')
      )
    end
  end

  describe '#update_account' do
    it 'updates the account friendly name' do
      response = instance_double(Faraday::Response, body: { 'sid' => account_sid, 'friendly_name' => 'New Name' })
      allow(connection).to receive(:post).and_return(response)

      result = instance.update_account(account_sid: account_sid, auth_token: auth_token, friendly_name: 'New Name')

      expect(connection).to have_received(:post).with(
        "/Accounts/#{account_sid}.json",
        hash_including('FriendlyName' => 'New Name')
      )
      expect(result[:result]).to include('friendly_name' => 'New Name')
    end
  end
end

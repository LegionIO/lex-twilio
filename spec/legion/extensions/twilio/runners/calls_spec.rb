# frozen_string_literal: true

RSpec.describe Legion::Extensions::Twilio::Runners::Calls do
  let(:test_class) do
    Class.new do
      include Legion::Extensions::Twilio::Runners::Calls
    end
  end
  let(:instance) { test_class.new }
  let(:account_sid) { 'test_account_sid' }
  let(:auth_token) { 'test_auth_token' }
  let(:connection) { instance_double(Faraday::Connection) }

  before do
    allow(instance).to receive(:connection).and_return(connection)
  end

  describe '#create_call' do
    it 'initiates an outbound call with a URL' do
      response = instance_double(Faraday::Response, body: { 'sid' => 'CA123', 'status' => 'queued' })
      allow(connection).to receive(:post).and_return(response)

      result = instance.create_call(
        to: '+15551234567', from: '+15559876543',
        url: 'https://example.com/twiml',
        account_sid: account_sid, auth_token: auth_token
      )

      expect(connection).to have_received(:post).with(
        "/Accounts/#{account_sid}/Calls.json",
        hash_including('To' => '+15551234567', 'From' => '+15559876543', 'Url' => 'https://example.com/twiml')
      )
      expect(result[:result]).to include('sid' => 'CA123')
    end

    it 'initiates a call with inline TwiML' do
      response = instance_double(Faraday::Response, body: { 'sid' => 'CA456' })
      allow(connection).to receive(:post).and_return(response)

      twiml = '<Response><Say>Hello</Say></Response>'
      result = instance.create_call(
        to: '+15551234567', from: '+15559876543',
        twiml: twiml, account_sid: account_sid, auth_token: auth_token
      )

      expect(connection).to have_received(:post).with(
        "/Accounts/#{account_sid}/Calls.json",
        hash_including('Twiml' => twiml)
      )
      expect(result[:result]).to include('sid' => 'CA456')
    end
  end

  describe '#get_call' do
    it 'fetches a call by SID' do
      response = instance_double(Faraday::Response, body: { 'sid' => 'CA123', 'status' => 'completed' })
      allow(connection).to receive(:get).and_return(response)

      result = instance.get_call(call_sid: 'CA123', account_sid: account_sid, auth_token: auth_token)

      expect(connection).to have_received(:get).with("/Accounts/#{account_sid}/Calls/CA123.json")
      expect(result[:result]).to include('status' => 'completed')
    end
  end

  describe '#list_calls' do
    it 'lists calls with default pagination' do
      response = instance_double(Faraday::Response, body: { 'calls' => [{ 'sid' => 'CA1' }] })
      allow(connection).to receive(:get).and_return(response)

      result = instance.list_calls(account_sid: account_sid, auth_token: auth_token)

      expect(connection).to have_received(:get).with(
        "/Accounts/#{account_sid}/Calls.json",
        hash_including('PageSize' => 50, 'Page' => 0)
      )
      expect(result[:result]).to have_key('calls')
    end

    it 'filters by status' do
      response = instance_double(Faraday::Response, body: { 'calls' => [] })
      allow(connection).to receive(:get).and_return(response)

      instance.list_calls(account_sid: account_sid, auth_token: auth_token, status: 'completed')

      expect(connection).to have_received(:get).with(
        "/Accounts/#{account_sid}/Calls.json",
        hash_including('Status' => 'completed')
      )
    end
  end

  describe '#update_call' do
    it 'redirects an active call' do
      response = instance_double(Faraday::Response, body: { 'sid' => 'CA123' })
      allow(connection).to receive(:post).and_return(response)

      result = instance.update_call(
        call_sid: 'CA123', url: 'https://example.com/new-twiml',
        account_sid: account_sid, auth_token: auth_token
      )

      expect(connection).to have_received(:post).with(
        "/Accounts/#{account_sid}/Calls/CA123.json",
        hash_including('Url' => 'https://example.com/new-twiml')
      )
      expect(result[:result]).to include('sid' => 'CA123')
    end

    it 'hangs up an active call' do
      response = instance_double(Faraday::Response, body: { 'sid' => 'CA123', 'status' => 'completed' })
      allow(connection).to receive(:post).and_return(response)

      instance.update_call(
        call_sid: 'CA123', status: 'completed',
        account_sid: account_sid, auth_token: auth_token
      )

      expect(connection).to have_received(:post).with(
        "/Accounts/#{account_sid}/Calls/CA123.json",
        hash_including('Status' => 'completed')
      )
    end
  end

  describe '#delete_call' do
    it 'deletes a call record' do
      response = instance_double(Faraday::Response, status: 204)
      allow(connection).to receive(:delete).and_return(response)

      result = instance.delete_call(call_sid: 'CA123', account_sid: account_sid, auth_token: auth_token)

      expect(connection).to have_received(:delete).with("/Accounts/#{account_sid}/Calls/CA123.json")
      expect(result[:result]).to be true
    end
  end
end

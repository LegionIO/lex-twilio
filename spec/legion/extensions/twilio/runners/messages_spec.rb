# frozen_string_literal: true

RSpec.describe Legion::Extensions::Twilio::Runners::Messages do
  let(:test_class) do
    Class.new do
      include Legion::Extensions::Twilio::Runners::Messages
    end
  end
  let(:instance) { test_class.new }
  let(:account_sid) { 'test_account_sid' }
  let(:auth_token) { 'test_auth_token' }
  let(:connection) { instance_double(Faraday::Connection) }

  before do
    allow(instance).to receive(:connection).and_return(connection)
  end

  describe '#send_message' do
    it 'sends an SMS message' do
      response = instance_double(Faraday::Response, body: { 'sid' => 'SM123', 'status' => 'queued' })
      allow(connection).to receive(:post).and_return(response)

      result = instance.send_message(to: '+15551234567', from: '+15559876543', body: 'Hello!', account_sid: account_sid, auth_token: auth_token)

      expect(connection).to have_received(:post).with(
        "/Accounts/#{account_sid}/Messages.json",
        hash_including('To' => '+15551234567', 'From' => '+15559876543', 'Body' => 'Hello!')
      )
      expect(result[:result]).to include('sid' => 'SM123')
    end

    it 'sends a message with messaging service sid' do
      response = instance_double(Faraday::Response, body: { 'sid' => 'SM456' })
      allow(connection).to receive(:post).and_return(response)

      result = instance.send_message(
        to: '+15551234567', body: 'Hello!',
        messaging_service_sid: 'MG123', account_sid: account_sid, auth_token: auth_token
      )

      expect(connection).to have_received(:post).with(
        "/Accounts/#{account_sid}/Messages.json",
        hash_including('To' => '+15551234567', 'MessagingServiceSid' => 'MG123')
      )
      expect(result[:result]).to include('sid' => 'SM456')
    end
  end

  describe '#get_message' do
    it 'fetches a message by SID' do
      response = instance_double(Faraday::Response, body: { 'sid' => 'SM123', 'body' => 'Hello!' })
      allow(connection).to receive(:get).and_return(response)

      result = instance.get_message(message_sid: 'SM123', account_sid: account_sid, auth_token: auth_token)

      expect(connection).to have_received(:get).with("/Accounts/#{account_sid}/Messages/SM123.json")
      expect(result[:result]).to include('sid' => 'SM123')
    end
  end

  describe '#list_messages' do
    it 'lists messages with default pagination' do
      response = instance_double(Faraday::Response, body: { 'messages' => [{ 'sid' => 'SM1' }] })
      allow(connection).to receive(:get).and_return(response)

      result = instance.list_messages(account_sid: account_sid, auth_token: auth_token)

      expect(connection).to have_received(:get).with(
        "/Accounts/#{account_sid}/Messages.json",
        hash_including('PageSize' => 50, 'Page' => 0)
      )
      expect(result[:result]).to have_key('messages')
    end

    it 'filters by from number' do
      response = instance_double(Faraday::Response, body: { 'messages' => [] })
      allow(connection).to receive(:get).and_return(response)

      instance.list_messages(account_sid: account_sid, auth_token: auth_token, from: '+15551234567')

      expect(connection).to have_received(:get).with(
        "/Accounts/#{account_sid}/Messages.json",
        hash_including('From' => '+15551234567')
      )
    end
  end

  describe '#redact_message' do
    it 'redacts a message body' do
      response = instance_double(Faraday::Response, body: { 'sid' => 'SM123', 'body' => '' })
      allow(connection).to receive(:post).and_return(response)

      result = instance.redact_message(message_sid: 'SM123', account_sid: account_sid, auth_token: auth_token)

      expect(connection).to have_received(:post).with(
        "/Accounts/#{account_sid}/Messages/SM123.json",
        { 'Body' => '' }
      )
      expect(result[:result]).to include('body' => '')
    end
  end

  describe '#delete_message' do
    it 'deletes a message' do
      response = instance_double(Faraday::Response, status: 204)
      allow(connection).to receive(:delete).and_return(response)

      result = instance.delete_message(message_sid: 'SM123', account_sid: account_sid, auth_token: auth_token)

      expect(connection).to have_received(:delete).with("/Accounts/#{account_sid}/Messages/SM123.json")
      expect(result[:result]).to be true
    end
  end
end

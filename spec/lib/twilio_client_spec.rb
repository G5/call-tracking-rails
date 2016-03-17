require 'twilio-ruby'
require 'vcr'
require 'vcr_helper'
require_relative '../../lib/twilio_client'
require "pry"

describe TwilioClient do
  let!(:account_sid) { ENV['TWILIO_ACCOUNT_SID'] }
  let!(:auth_token) { ENV['TWILIO_AUTH_TOKEN'] }
  let!(:app_sid) { ENV['TWIML_APPLICATION_SID'] }

  before do
    ENV['TWILIO_ACCOUNT_SID'] = 'ACCOUNT_SID'
    ENV['TWILIO_AUTH_TOKEN'] = 'AUTH_TOKEN'
    ENV['TWIML_APPLICATION_SID'] = 'APP_SID'
  end

  after do
    ENV['TWILIO_ACCOUNT_SID'] = account_sid
    ENV['TWILIO_AUTH_TOKEN'] = auth_token
    ENV['TWIML_APPLICATION_SID'] = app_sid
  end

  describe '.available_phone_numbers' do
    it "returns the first 10 phone numbers" do
      VCR.use_cassette('available-phone-numbers') do
        phone_numbers = described_class.available_phone_numbers('415', '')
        expect(phone_numbers.count).to eq(1)
      end
    end
  end

  describe '.purchase_phone_number' do
    it 'purchases a phone number' do
      VCR.use_cassette('purchase-phone-number') do
        phone_number = described_class.purchase_phone_number('+14152339867')
        expect(phone_number.friendly_name).to_not be_empty
      end
    end
  end
end

class TwilioClient
  def self.available_phone_numbers(area_code, zip_code)
    new.available_phone_numbers(area_code, zip_code)
  end

  def self.purchase_phone_number(phone_number)
    new.purchase_phone_number(phone_number)
  end

  def initialize
    @client = Twilio::REST::Client.new
  end

  def available_phone_numbers(area_code = '415', zip_code)
    client.available_phone_numbers.
      get('US').local.list(area_code: area_code, inPostalCode: zip_code).take(1)
  end

  def purchase_phone_number(phone_number)
    application_sid = ENV['TWIML_APPLICATION_SID'] || sid
    client.incoming_phone_numbers.
      create(phone_number: phone_number, voice_application_sid: application_sid)
  end

  private

  DEFAULT_APPLICATION_NAME = 'Call tracking app'

  def sid
    applications = @client.account.applications.list(friendly_name: DEFAULT_APPLICATION_NAME)
    if applications.any?
      applications.first.sid
    else
      @client.account.applications.create(friendly_name: DEFAULT_APPLICATION_NAME).sid
    end
  end

  attr_reader :client
end

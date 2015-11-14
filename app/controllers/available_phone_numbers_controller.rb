class AvailablePhoneNumbersController < ApplicationController
  def index
    area_code = params["area-code"]
    zip_code = params["zip-code"]
    @phone_numbers = ::TwilioClient.available_phone_numbers(area_code, zip_code)
  end
end

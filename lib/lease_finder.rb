class LeaseFinder
  def initialize(params)
    @cid = params[:ga_client_id]
    @location = G5Updatable::Location.where(urn: params[:location_urn]).first
  end

  def find_lease
    lease = find_existing_lease
    lease ||= find_expired_lease

    if lease.nil?
      max = @location.client.try(:twilio_max_pool) || ENV['DEFAULT_MAX_POOL']
      count = Lease.active.count
      lease ||= purchase_number if count < max.to_i
    end

    lease ||= oldest_lease
    lease
  end

  private

  def find_existing_lease
    lease = Lease.where(cid: @cid).active.by_location(@location.urn).first
    lease.touch if lease.present?
    lease
  end

  def find_expired_lease
    lease = Lease.active.by_location( @location.urn).expirable(10.minutes.ago).first

    if lease.present?
      lease.expire
      return Lease.create({cid: @cid, lead_source: lease.lead_source})
    else
      nil
    end
  end

  def oldest_lease
    lease = Lease.by_location(@location.urn).active.order(updated_at: :asc).first

    if lease.present?
      lease.expire
      return Lease.create({cid: @cid, lead_source: lease.lead_source})
    else
      nil
    end
  end

  def purchase_number
    client = @location.client
    location_direct_number = GlobalPhone.parse(@location.phone_number)
    area_code = location_direct_number.national_format[/\(.*?\)/].gsub('(', '').gsub(')', '')
    zip_code = location.postal_code.strip()
    begin
      phone_number = ::TwilioClient.available_phone_numbers(area_code, zip_code).first
      phone_number ||= ::TwilioClient.available_phone_numbers(area_code, "").first
      phone_number ||= ::TwilioClient.available_phone_numbers("", zip_code).first
      raise "I01: No phone numbers available in area code or zip code." unless phone_number
      raise "Be careful. Phone numbers are expensive!!!" unless (ENV['TWILIO_SPEND_APPROVED'] == true)
      twilio_number = TwilioClient.purchase_phone_number(phone_number.phone_number)
      ls = LeadSource.create(name: "#{client.name} | #{location.name}",
                             incoming_number: twilio_number.friendly_name,
                             forwarding_number: location_direct_number.national_format,
                             client_urn: client.urn,
                             location_urn: location.urn)
      new_lease = Lease.create({cid: cid, lead_source: ls})
      new_lease.lead_source.incoming_number
    rescue Exception => e
      Rails.logger.error e.message
      Rails.logger.error e.backtrace.inspect
      location_direct_number.national_format
    end
  end
end

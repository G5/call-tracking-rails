class LeasesController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    Rails.logger.debug params.to_s
    cid = params[:Cid]
    client_urn = params[:ClientUrn]
    location_urn = params[:LocationUrn]
    expired_time = DateTime.now - 10.minutes

    if !valid_params?
      render status: :not_found, json: {:error => 'Invalid parameter'}
      return
    end

    # Refactor as Lookup Existing Lease
    l = Lease.where("status = :status", {status: "active"}).where("cid = :cid", {cid: params[:Cid]}).joins(:lead_source).where(
        "client_urn = :client_urn AND location_urn = :location_urn",
        {client_urn: params[:ClientUrn], location_urn: params[:LocationUrn]}).first
    unless l.nil?
      l.touch
      render status: :ok, json: {:phone_number => l.lead_source.incoming_number}
      return
    end

    # Is there any lease that I can reclaim?
    l = Lease.where("status = :status", {status: "active"}).where("leases.updated_at <= :expired_time", {expired_time: expired_time}).joins(:lead_source).where(
        "client_urn = :client_urn AND location_urn = :location_urn",
        {client_urn: client_urn, location_urn: location_urn}).order("leases.updated_at ASC").first
    unless l.nil?
      l.status = "expired"
      l.save
      new_lease = Lease.create({cid: cid, lead_source: l.lead_source})
      render status: :ok, json: {:phone_number => new_lease.lead_source.incoming_number}
      return
    end

    # Buy a phone number
    client = G5Updatable::Client.find_by_urn(params[:ClientUrn])
    location = client.locations.find_by_urn(params[:LocationUrn])
    location_direct_number = GlobalPhone.parse(location.phone_number)
    area_code = location_direct_number.national_format[/\(.*?\)/].gsub('(', '').gsub(')', '')
    zip_code = location.postal_code.strip()
    begin
      phone_number = ::TwilioClient.available_phone_numbers(area_code, zip_code).first
      phone_number = ::TwilioClient.available_phone_numbers(area_code, "").first unless phone_number
      phone_number = ::TwilioClient.available_phone_numbers("", zip_code).first unless phone_number
      raise "I01: No phone numbers available in area code or zip code." unless phone_number
      twilio_number = TwilioClient.purchase_phone_number(phone_number.phone_number)
      ls = LeadSource.create(name: "#{client.name} | #{location.name}",
                             incoming_number: twilio_number.friendly_name,
                             forwarding_number: location_direct_number.national_format,
                             client_urn: client.urn,
                             location_urn: location.urn)
      new_lease = Lease.create({cid: cid, lead_source: ls})
      render status: :ok, json: {:phone_number => new_lease.lead_source.incoming_number}
    rescue Exception => e
      Rails.logger.error e.message
      Rails.logger.error e.backtrace.inspect
      render status: :ok, json: {:phone_number => location_direct_number.national_format}
    end

  end

  private
  def valid_params?
    !G5Updatable::Location.where("urn = :urn", {urn: params[:LocationUrn]}).first.nil?
  end

end


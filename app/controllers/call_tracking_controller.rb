class CallTrackingController < ApplicationController
  include ParamsCleaner
  skip_before_action :verify_authenticity_token

  def forward_call
    Rails.logger.debug "--- CALL START ---"
    Rails.logger.debug params.to_s
    #lead = Lead.create(lead_params)
    #lead.properties = params
    #lead.save
    render text: twilio_response.text
  end

  def call_end
    Rails.logger.debug "--- CALL END ---"
    Rails.logger.debug params.to_s

    lead = Lead.create(lead_params)
    lead.properties = clean_rails_parameters(params)
    lead.save

    lease = Lease.active.where(lead_source_id: lead.lead_source_id).first
    loc = G5Updatable::Location.where(urn: lead.lead_source.location_urn)

    post_params = lead.properties
    post_params["ga_client_id"] = lease.cid
    post_params["location_uid"] = loc.uid
    Net::HTTP.post_form(URI.parse('http://g5-cls-1skmeepf-clowns-monkeys.herokuapp.com/twilio_calls'), lead.properties)

    render status: :ok, json: @controller.to_json
  end

  private

  def twilio_response
    phone_number = lead_source.forwarding_number
    Twilio::TwiML::Response.new do |r|
      r.Play "http://demo.twilio.com/hellomonkey/monkey.mp3"
      r.Dial phone_number, action: '/call-tracking/call-end', method: 'post'
    end
  end

  def lead_params
    {
      lead_source: lead_source,
      phone_number: params[:Caller],
      city: params[:FromCity],
      state: params[:FromState],
      caller_zip: params[:CallerZip],
      caller_name: params[:CallerName],
      call_status: params[:CallStatus],
      call_duration: params[:DialCallDuration]
    }
  end

  def lead_source
    incoming_number = GlobalPhone.parse(params[:Called]).national_format
    LeadSource.find_by_incoming_number(incoming_number)
  end
end

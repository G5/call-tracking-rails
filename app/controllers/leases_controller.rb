class CallTrackingController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    Lease.create(lease_params)
    render status: :ok, json: @controller.to_json
  end

private
  def lease_params
    {
        lead_source: lead_source,
        cid: params[:Cid]
    }
  end

  def lead_source
    client_urn = params[:ClientUrn]
    location_urn =  params[:LocationUrn]

    # Try to find a provisioned phone number
    LeadSource.where("created_at >= :start_date AND created_at <= :end_date",
                 {start_date: params[:start_date], end_date: params[:end_date]})

    LeadSource.all.where({})

    # If none are available, provision one

    # If something goes wrong, return direct phone number (and log this)

    LeadSource.find_by_incoming_number(incoming_number)


    incoming_number = GlobalPhone.parse(params[:Called]).national_format
    LeadSource.find_by_incoming_number(incoming_number)
  end



end


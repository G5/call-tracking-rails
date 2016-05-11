class LeasesController < ApplicationController
  skip_before_action :verify_authenticity_token
  after_filter  :set_access_control_headers

  def set_access_control_headers
    headers['Access-Control-Allow-Origin'] = '*'
  end

  def create
    if !valid_params?
      render status: :bad_request, json: {:error => 'Invalid parameter'}
      return
    end

    lease = LeaseFinder.new(params).find_lease
    phone_number = lease.lead_source.incoming_number
    render status: :ok, json: {:phone_number => phone_number}
  end

  private
  def valid_params?
    !G5Updatable::Location.where("urn = :urn", { urn: params[:location_urn] }).first.nil?
  end
end


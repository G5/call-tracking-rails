class Lease < ActiveRecord::Base
  belongs_to :lead_source

  scope :active, -> { where(status: 'active') }
  scope :expirable, -> (time) { where("leases.updated_at <= ?", time) }
  scope :by_location, -> (client_urn, location_urn) { joins(:lead_source).where("client_urn = '#{client_urn}' and location_urn = '#{location_urn}'") }

  def expire
    update_attributes!(status: "expired")
  end
end

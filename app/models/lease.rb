class Lease < ActiveRecord::Base
  belongs_to :lead_source

  scope :active, -> { where(status: 'active') }
  scope :expirable, -> (time) { where("leases.updated_at <= ?", time) }

  scope :by_location, -> (location_urn) {
    joins(:lead_source).where(lead_sources: {location_urn: location_urn})
  }

  def expire
    update_attributes!(status: "expired")
  end
end

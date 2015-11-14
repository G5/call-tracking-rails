class Lease < ActiveRecord::Base
  belongs_to :lead_source
end

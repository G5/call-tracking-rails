class AddClientAndLocationPropertiesToLeadSource < ActiveRecord::Migration
  def change
    add_column :lead_sources, :client_urn, :string
    add_column :lead_sources, :location_urn, :string
  end
end

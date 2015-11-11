class DashboardController < ApplicationController
  def index
    @lead_sources = LeadSource.all
    @leads = Lead.all
  end
end

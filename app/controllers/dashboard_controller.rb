class DashboardController < ApplicationController
  before_filter :authenticate_user!

  def index
    @lead_sources = LeadSource.all
  end
end

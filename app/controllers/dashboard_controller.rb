include SmartListing::Helper::ControllerExtensions

class DashboardController < ApplicationController
  helper  SmartListing::Helper
  def index
    @lead_sources = LeadSource.all
    @leads = Lead.all.order(id: :desc)
    # #@leads = smart_listing_create(:leads, Lead.all, partial: "dashboard/leads")
    # # Make users initally sorted by name ascending
    # smart_listing_create :users,
    #                      User.all,
    #                      partial: "users/list",
    #                      default_sort: {created_at: "desc"}
  end
end

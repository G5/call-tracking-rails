Rails.application.routes.draw do
#  mount G5Authenticatable::Engine => '/g5_auth'
  mount G5Updatable::Engine => '/g5_updatable'
  root 'dashboard#index'

  post 'call-tracking/forward-call' => 'call_tracking#forward_call', as: :forward_call
  post 'call-tracking/call-end' => 'call_tracking#call_end', as: :end_call
  post 'lease' => 'leases#create', as: :create

  get 'statistics/leads_by_source' => 'statistics#leads_by_source', as: :leads_by_source
  get 'statistics/leads_by_city' => 'statistics#leads_by_city', as: :leads_by_city
end

require 'rails_helper'

describe 'Routes' do
  describe 'dashboard' do
    specify { expect({get: '/'}).to route_to(controller: 'dashboard', action: 'index') }
  end

  describe 'tracking' do
    specify { expect({post: '/call-tracking/forward-call'}).to route_to(controller: 'call_tracking', action: 'forward_call') }
    specify { expect({post: '/call-tracking/call-end'}).to route_to(controller: 'call_tracking', action: 'call_end') }
  end

  describe 'leases' do
    specify { expect({post: '/lease'}).to route_to(controller: 'leases', action: 'create') }
  end

  describe 'statistics' do
    specify { expect({get: '/statistics/leads_by_source'}).to route_to(controller: 'statistics', action: 'leads_by_source') }
    specify { expect({get: '/statistics/leads_by_city'}).to route_to(controller: 'statistics', action: 'leads_by_city') }
  end
end

require 'rails_helper'

RSpec.describe Lease do
  describe '.expire' do
    let(:lease) { FactoryGirl.create(:lease) }
    it "sets the lease status to expired" do
      lease.expire
      expect(lease.reload.status).to eq("expired")
    end
  end

  context "scopes" do
    describe "active" do
      let!(:lease) { FactoryGirl.create(:lease) }
      let!(:expired) { FactoryGirl.create(:lease, status: "expired") }
      subject(:active_leases) { Lease.active }

      it "returns the lease" do
        expect(active_leases.count).to eq(1)
        expect(active_leases.first).to eq(lease)
      end
    end

    describe "expirable" do
      let!(:lease) { FactoryGirl.create(:lease, updated_at: 1.month.ago) }
      let!(:other) { FactoryGirl.create(:lease) }
      subject(:expirable_leases) { Lease.expirable(10.minutes.ago) }

      it "returns the lease" do
        expect(expirable_leases.count).to eq(1)
        expect(expirable_leases.first).to eq(lease)
      end
    end

    describe "by_location" do
      let(:client_urn) { "client_urn" }
      let(:location_urn) { "location_urn" }
      let(:source) { FactoryGirl.create(:lead_source, client_urn: client_urn, location_urn: location_urn) }

      let!(:lease) { FactoryGirl.create(:lease, lead_source: source) }
      let!(:other) { FactoryGirl.create(:lease) }
      subject(:by_loc) { Lease.by_location(client_urn, location_urn) }

      it "returns the leases" do
        expect(by_loc.count).to eq(1)
        expect(by_loc.first).to eq(lease)
      end
    end
  end
end


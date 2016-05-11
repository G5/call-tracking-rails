require 'rails_helper'

RSpec.describe LeaseFinder do
  let(:client) { FactoryGirl.create(:client, properties: { twilio_max_pool: max_pool }) }
  let(:location) { FactoryGirl.create(:location, client: client) }
  let(:lead_source) { FactoryGirl.create(:lead_source, location_urn: location.urn) }
  let(:cid) { '123456-cid' }
  let(:finder) { LeaseFinder.new({ga_client_id: cid, location_urn: location.urn}) }
  let(:max_pool) { 7 }

  describe '.find_lease' do
    subject(:lease) { finder.find_lease }
    context "with and existing lease" do
      let!(:existing_lease) { FactoryGirl.create(:lease, cid: cid, lead_source: lead_source) }

      it 'returns the existing lease' do
        expect(lease).to eq(existing_lease)
      end
    end

    context "with an expired lease that can be reclaimed" do
      let!(:expired_lease) do
        FactoryGirl.create(
          :lease,
          cid: cid,
          lead_source: lead_source,
          updated_at: 12.minutes.ago
        )
      end

      it 'returns the existing lease' do
        expect(lease.cid).to eq('123456-cid')
        expect(lease.lead_source).to eq(lead_source)
      end
    end

    context "When there are not expired leases, but the pools is not at max" do
      let!(:old_lease) do
        FactoryGirl.create(
          :lease,
          cid: "other-cid",
          lead_source: lead_source,
          updated_at: 3.minutes.ago
        )
      end

      it "purchases a new number" do
        expect(finder).to receive(:purchase_number)
        finder.find_lease
      end
    end

    context "with no expired leases and at the pool cap" do
      let!(:max_pool) { 2 }

      let!(:old_lease) do
        FactoryGirl.create(
          :lease,
          cid: "other-cid",
          lead_source: lead_source,
          updated_at: 3.minutes.ago
        )
      end

      let!(:oldest_lease) do
        FactoryGirl.create(
          :lease,
          cid: "other-other-cid",
          lead_source: lead_source,
          updated_at: 5.minutes.ago
        )
      end

      it 'returns the existing lease' do
        expect(lease.cid).to eq('123456-cid')
        expect(lease.lead_source).to eq(lead_source)
      end

    end
  end
end

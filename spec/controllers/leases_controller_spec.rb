require 'rails_helper'

describe LeasesController do
  describe "#create" do
    context "with invalid params" do
      let(:lease_post) { post :create, { urn: "does not exists" } }

      it "returns and error code" do
        expect(lease_post.status).to eq(400)
        expect(lease_post.body).to include("Invalid parameter")
      end
    end

    context "with a valid requst" do
      let(:client) { FactoryGirl.create(:client) }
      let!(:location) { FactoryGirl.create(:location, client: client) }
      let(:lead_source) { FactoryGirl.create(:lead_source, incoming_number: "+15555555555", location_urn: location.urn) }
      let!(:lease) { FactoryGirl.create(:lease, lead_source: lead_source, updated_at: 30.minutes.ago) }
      let(:lease_post) { post :create, { LocationUrn: location.urn} }

      before do
        allow_any_instance_of(LeaseFinder).to receive(:purchase_number).and_return(nil)
      end

      it "returns a phone number" do
        expect(JSON.parse(lease_post.body)["phone_number"]).to eq("+15555555555")
      end
    end
  end
end

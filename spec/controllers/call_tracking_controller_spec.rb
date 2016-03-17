require 'rails_helper'

describe CallTrackingController do
  describe "#create" do
    let(:lead_source) { build(:lead_source, name: 'Hometown', forwarding_number: '+593 99 267 0240') }
    before { allow(LeadSource).to receive(:find_by_incoming_number) { lead_source } }

    describe "POST#forward_call" do
      let(:response) { post :forward_call, "Called" => '+12568417275', "Caller" => '+12568417333', "FromCity" => 'San Diego', "FromState" => 'CA' }

      it "renders a TwiML text response" do
        expect(response.body).to eq("<?xml version=\"1.0\" encoding=\"UTF-8\"?><Response><Dial action=\"/call-tracking/call-end\" method=\"post\">+593 99 267 0240</Dial></Response>")
      end
    end

    describe "POST#call_end" do
      let(:response) { post :call_end, "Called" => '+12568417275', "Caller" => '+12568417333', "FromCity" => 'San Diego', "FromState" => 'CA' }
      let(:client) { FactoryGirl.create(:client) }
      let(:location) { FactoryGirl.create(:location, client: client) }
      let(:lead_source) { FactoryGirl.create(:lead_source, location_urn: location.urn, client_urn: client.urn, incoming_number: '+12568417275') }
      let!(:lease) { FactoryGirl.create(:lease, lead_source: lead_source) }

      before do
        stub_request(:post, "https://g5-cls-1234-client.herokuapp.com/twilio_calls").to_return(:status => 200, :body => "", :headers => {})
      end

      it "renders some json" do
        expect(response.body).to eq("null")
      end

      it "creates a lead" do
        expect { response }.to change(Lead, :count).by(1)
      end
    end
  end
end

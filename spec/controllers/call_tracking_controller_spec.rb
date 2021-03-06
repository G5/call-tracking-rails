require 'rails_helper'

describe CallTrackingController do
  describe "#create" do

    before do
      lead_source = build(:lead_source, name: 'Hometown', forwarding_number: '+593 99 267 0240')
      allow(LeadSource).to receive(:find_by_incoming_number) { lead_source }
    end

    it "creates a lead" do
      expect do
        post :forward_call, "Called" => '+12568417275', "Caller" => '+12568417333', "FromCity" => 'San Diego', "FromState" => 'CA'
      end.to change(Lead, :count).by(1)
    end

    it "renders a TwiML text response" do
      post :forward_call, "Called" => '+12568417275', "Caller" => '+12568417333', "FromCity" => 'San Diego', "FromState" => 'CA'
      expect(response.body).to eq("<?xml version=\"1.0\" encoding=\"UTF-8\"?><Response><Play>http://demo.twilio.com/hellomonkey/monkey.mp3</Play><Dial action=\"/call-tracking/call-end\" method=\"post\">+593 99 267 0240</Dial></Response>")
    end
  end
end

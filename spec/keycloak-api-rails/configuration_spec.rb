require "spec_helper"

describe Keycloak::Configuration do
  let!(:server_url) { "http://localhost:8080/auth/" }
  let!(:realm_id) { "demo" }
  let!(:token_expiration_tolerance_in_seconds) { 30 }

  let!(:subdomain) { 'hdfc' }
  let!(:request) do
    instance_double('ActionDispatch::Request', subdomain: subdomain)
  end

  describe ".from" do
    context 'based on request' do
      before do
        Keycloak.configure_with_request do |config, request|
          config.server_url = server_url
          config.realm_id = request.subdomain
          config.token_expiration_tolerance_in_seconds = token_expiration_tolerance_in_seconds
        end
      end

      let(:config) do
        described_class.from(request)
      end

      it "is configurable based on request" do
        expect(config.server_url).to eq(server_url)
        expect(config.token_expiration_tolerance_in_seconds).to eq(token_expiration_tolerance_in_seconds)
        expect(config.realm_id).to eq(subdomain)
      end
    end

    context 'static configuration' do
      before do
        Keycloak.configure do |config|
          config.server_url = server_url
          config.realm_id = realm_id
          config.token_expiration_tolerance_in_seconds = token_expiration_tolerance_in_seconds
        end
      end
      let(:config) { Keycloak.config }

      it "is configurable without request" do
        expect(config.server_url).to eq(server_url)
        expect(config.token_expiration_tolerance_in_seconds).to eq(token_expiration_tolerance_in_seconds)
        expect(config.realm_id).to eq(realm_id)
      end
    end
  end
end


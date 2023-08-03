require "spec_helper"

describe Keycloak::Configuration do
  let!(:server_url) { "http://localhost:8080/auth/" }
  let!(:realm_id) { "demo" }
  let!(:token_expiration_tolerance_in_seconds) { 30 }

  let!(:subdomain) { 'hdfc' }
  let!(:request) do
    instance_double('ActionDispatch::Request', subdomain: subdomain)
  end
  let(:config) { described_class.from(request) }

  describe ".from" do
    context 'based on request' do
      before do
        Keycloak.configure_with_request do |config, request|
          config.server_url = server_url
          config.realm_id = request.subdomain
          config.token_expiration_tolerance_in_seconds = token_expiration_tolerance_in_seconds
        end
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

  describe '#key_resolver' do
    context 'when not set' do
      it 'returns PublicKeyCachedResolver as default value' do
        expect(config.key_resolver).to eq(Keycloak::PublicKeyCachedResolver)
      end
    end

    context 'when set' do
      before do
        Keycloak.configure do |config|
          config.key_resolver = pub_key_resolver
        end
      end
      let(:pub_key_resolver) { Class.new }
      let(:config) { Keycloak.config }

      it 'returns the set value' do
        expect(config.key_resolver).to eq(pub_key_resolver)
      end
    end
  end
end


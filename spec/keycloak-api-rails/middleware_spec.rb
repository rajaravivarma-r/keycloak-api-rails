RSpec.describe Keycloak::Middleware do
  let(:token) {
  let(:app) { double('callable') }
  let(:middleware) { described_class.new(app) }
  let(:env) do
    {
      "REQUEST_METHOD" => :get,
      "PATH_INFO" => '/home',
      "REQUEST_URI" => 'http://localhost:3000/home'
    }
  end
  let(:service) do
    instance_double('Keycloak::Service')
  end

  around do |example|
    old_service = Keycloak.instance_variable_get(:@service)
    Keycloak.instance_variable_set(:@service, nil)
    example.run
    Keycloak.instance_variable_set(:@service, old_service)
  end

  describe 'authentication' do
    context 'when middleware to be skipped' do
      before do
        expect(service).to(
          receive(:need_middleware_authentication?).and_return(false)
        )
        expect(Keycloak::Service).to receive(:new).and_return(service)
        expect(app).to receive(:call).with(env).once
      end

      it 'skips authentication and calls rack app' do
        middleware.call(env)
      end
    end

    context 'when middleware authentication is enabled' do
      before do
        expect(service).to(
          receive(:need_middleware_authentication?).and_return(true)
        )
        expect(service).to(
          receive(:read_token)
        )
        expect(Keycloak::Service).to receive(:new).and_return(service)
        expect(app).to receive(:call).with(env).once
      end

      it 'authenticates in the middleware' do
      end
    end
  end
end

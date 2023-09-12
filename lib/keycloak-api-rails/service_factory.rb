module Keycloak
  class ServiceFactory
    def from_env(env)
      config = Keycloak::Configuration.from(ActionDispatch::Request.new(env))
      http_client = Keycloak::HTTPClient.new(config)
      key_resolver = config.key_resolver.from_configuration(http_client, config)
      service = Keycloak::Service.new(key_resolver, config)
    end
  end
end

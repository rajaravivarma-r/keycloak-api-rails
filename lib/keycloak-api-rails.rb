require "logger"
require "json/jwt"
require "uri"
require "date"
require "net/http"

require_relative "keycloak-api-rails/authentication"
require_relative "keycloak-api-rails/configuration"
require_relative "keycloak-api-rails/http_client"
require_relative "keycloak-api-rails/token_error"
require_relative "keycloak-api-rails/helper"
require_relative "keycloak-api-rails/public_key_resolver"
require_relative "keycloak-api-rails/public_key_cached_resolver"
require_relative "keycloak-api-rails/service"
require_relative "keycloak-api-rails/middleware"
require_relative "keycloak-api-rails/railtie" if defined?(Rails)

module Keycloak
  class MissingConfiguration < StandardError
    def initialize
      super(
        'Keycloak.configure was never called. Perhaps, you meant to create ' \
        'the service using Keycloak::ServiceFactor.from_env(env)?'
      )
    end
  end

  def self.configure
    yield @configuration ||= Keycloak::Configuration.new
  end

  def self.configure_with_request(&block)
    @configuration_block = block
  end

  def self.configuration_block
    @configuration_block
  end

  def self.config
    raise MissingConfiguration.new if @configuration.nil?

    @configuration
  end

  def self.http_client
    @http_client ||= Keycloak::HTTPClient.new(config)
  end

  def self.public_key_resolver
    @public_key_resolver ||= PublicKeyCachedResolver.from_configuration(http_client, config)
  end

  def self.service
    @service ||= Keycloak::Service.new(public_key_resolver)
  end

  def self.logger
    config.logger
  end

  def self.load_configuration
    configure do |config|
      config.server_url                             = nil
      config.realm_id                               = nil
      config.logger                                 = ::Logger.new(STDOUT)
      config.skip_paths                             = {}
      config.opt_in                                 = false
      config.token_expiration_tolerance_in_seconds  = 10
      config.public_key_cache_ttl                   = 86400
      config.custom_attributes                      = []
    end
  end

  load_configuration
end

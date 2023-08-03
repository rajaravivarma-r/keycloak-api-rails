module Keycloak
  Configuration = Struct.new(
    :server_url,
    :realm_id,
    :skip_paths,
    :opt_in,
    :token_expiration_tolerance_in_seconds,
    :public_key_cache_ttl,
    :custom_attributes,
    :logger,
    :ca_certificate_file,
    :key_resolver,
    keyword_init: true
  ) do
    def self.from(request)
      new.tap do |config|
        Keycloak.configuration_block.call(config, request)
      end
    end

    def key_resolver
      self[:key_resolver] || PublicKeyCachedResolver
    end
  end
end

RSpec.shared_examples 'Helper method calls' do
  it 'calls the expected methods with correct arguments' do
    expect(Helper).to receive(:assign_current_user_id).with(env, decoded_token)
    expect(Helper).to receive(:assign_current_authorized_party).with(env, decoded_token)
    expect(Helper).to receive(:assign_current_user_email).with(env, decoded_token)
    expect(Helper).to receive(:assign_current_user_locale).with(env, decoded_token)
    expect(Helper).to receive(:assign_current_user_custom_attributes).with(env, decoded_token, config.custom_attributes)
    expect(Helper).to receive(:assign_realm_roles).with(env, decoded_token)
    expect(Helper).to receive(:assign_resource_roles).with(env, decoded_token)
    expect(Helper).to receive(:assign_keycloak_token).with(env, decoded_token)
  end
end

Rails.application.config.middleware.use OmniAuth::Builder do
  # SWorD consumer keys and secret
  # provider :provider_name, '[consumer_key]', '[consumer_secret]'
  provider :twitter, '5ODI4PtWJBq7TOGdHgJgUw', 'fqObTrGWLsxosTBwOmMZHTTFu4uqwOuKg2KLPcHWFQk'
  provider :facebook, '	217099658436408', '49339c270b055f09207c0f84868a5bc6'
end

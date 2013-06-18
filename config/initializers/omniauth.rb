Rails.application.config.middleware.use OmniAuth::Builder do
  # SWorD consumer keys and secret
  # provider :provider_name, '[consumer_key]', '[consumer_secret]'
  provider :twitter, '6uTIase88o1Oap6Yyk6WKw', 'PCt0butRBr4EOrNU7x0LZgFNmmWxDZMGttAp3gpdXJA'
  provider :facebook, '	217099658436408', '49339c270b055f09207c0f84868a5bc6', scope: 'email, user_birthday, user_about_me, user_location, user_website ', :display => 'popup',client_options: { ssl: { ca_file: "#{Rails.root}/config/cacert.pem" } }


end

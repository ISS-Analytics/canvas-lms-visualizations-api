GOOGLE_OAUTH = 'https://accounts.google.com/o/oauth2/auth'
GOOGLE_PARAMS = "?response_type=code&client_id=#{ENV['CLIENT_ID']}"

# Visualizations for Canvas LMS Classes: Teacher login
class CanvasVisualizationAPI < Sinatra::Base
  include AppLoginHelper

  google_client_id = lambda do
    "#{GOOGLE_OAUTH}#{GOOGLE_PARAMS}&redirect_uri=#{ENV['APP_URL']}"\
    'oauth2callback_gmail&scope=email'
  end

  encrypt_email_address = lambda do
    access_token = CallbackGmail.new(params).call
    email = GoogleTeacherEmail.new(access_token).call
    encrypted_email =
    if find_teacher(email) then EncryptPayload.new(email).call
    else SaveTeacher.new(email).call
    end
    { encrypted_email: encrypted_email, email: email }.to_json
  end

  verify_password = lambda do
    email = TokenClearingHouse.new(env['HTTP_AUTHORIZATION']).call
    halt(*email.values) if email.class == Hash
    password = params['password']
    VerifyPassword.new(email, password).call
  end

  save_password_return_jwt = lambda do
    email = TokenClearingHouse.new(env['HTTP_AUTHORIZATION']).call
    halt(*email.values) if email.class == Hash
    password = params['password']
    SaveTeacherPassword.new(email, password).call
  end

  get '/api/v1/client_id/?', &google_client_id
  get '/api/v1/use_callback_code/?', &encrypt_email_address
  get '/api/v1/verify_password/?', &verify_password
  post '/api/v1/save_password/?', &save_password_return_jwt
end

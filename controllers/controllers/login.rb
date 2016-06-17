require 'jwt'

GOOGLE_OAUTH = 'https://accounts.google.com/o/oauth2/auth'
GOOGLE_PARAMS = "?response_type=code&client_id=#{ENV['CLIENT_ID']}"

# Visualizations for Canvas LMS Classes
class CanvasVisualizationAPI < Sinatra::Base
  include AppLoginHelper

  google_client_id = lambda do
    "#{GOOGLE_OAUTH}#{GOOGLE_PARAMS}&redirect_uri=#{ENV['APP_URL']}"\
    'oauth2callback_gmail&scope=email'
  end

  store_email_as_jwt = lambda do
    access_token = CallbackGmail.new(params).call
    email = GoogleTeacherEmail.new(access_token).call
    if find_teacher(email) then StoreEmailAsJWT.new(email).call
    else SaveTeacher.new(email).call
    end
  end

  verify_password = lambda do
    payload = BearerToken.new(env['HTTP_AUTHORIZATION'])
    halt 400 unless payload.valid?
    payload = DecryptPayload.new(payload.bearer_token)
    payload = begin payload.call
    rescue => e
      logger.error e
      halt 401
    end
    payload = JSON.parse payload
    email = payload['email']
    password = payload['password']
    result = VerifyPassword.new(email, password).call
    puts result
    result
  end

  save_password_return_jwt = lambda do
    payload = BearerToken.new(env['HTTP_AUTHORIZATION'])
    halt 400 unless payload.valid?
    payload = DecryptPayload.new(payload.bearer_token)
    payload = begin payload.call
    rescue => e
      logger.error e
      halt 401
    end
    payload = JSON.parse payload
    email = payload['email']
    password = payload['password']
    SaveTeacherPassword.new(email, password).call
  end

  get '/api/v1/client_id/?', &google_client_id
  get '/api/v1/use_callback_code/?', &store_email_as_jwt
  get '/api/v1/verify_password/?', &verify_password
  post '/api/v1/save_password/?', &save_password_return_jwt
end

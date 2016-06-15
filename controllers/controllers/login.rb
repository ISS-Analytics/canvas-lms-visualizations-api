GOOGLE_OAUTH = 'https://accounts.google.com/o/oauth2/auth'
GOOGLE_PARAMS = "?response_type=code&client_id=#{ENV['CLIENT_ID']}"

# Visualizations for Canvas LMS Classes
class CanvasVisualizationAPI < Sinatra::Base
  google_client_id = lambda do
    "#{GOOGLE_OAUTH}#{GOOGLE_PARAMS}&redirect_uri=#{ENV['APP_URL']}"\
    'oauth2callback_gmail&scope=email'
  end

  get_email_from_google = lambda do
    access_token = CallbackGmail.new(params).call
    GoogleTeacherEmail.new(access_token).call
  end

  get '/api/v1/client_id/?', &google_client_id
  get '/api/v1/use_callback_code/?', &get_email_from_google
end

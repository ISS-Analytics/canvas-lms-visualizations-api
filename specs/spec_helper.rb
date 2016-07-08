system 'rm db/test.db'
ENV['RACK_ENV'] = 'test'
system 'rake db:migrate'

require 'minitest/autorun'
require 'minitest/rg'
require 'rack/test'

Dir.glob('./{models,helpers,controllers,services,values}/*.rb').each do |file|
  require file
end

include Rack::Test::Methods

EMAIL_ADDRESS = 'james.uanhoro@gmail.com'
PASSWORD = 'password'
HTTP_AUTHORIZATION = 'AUTHORIZATION'
CANVAS_URL = 'https://canvas.instructure.com/'
CANVAS_TOKEN = ENV['CANVAS_TOKEN']
FIRST_POSITION = OBFUSCATED_POSITION = 0
URL_POSITION = 1
ACCESS_KEY_POSITION = 2
NO_SAVED_PASSWORD = 'no password found'
WRONG_PASSWORD = 'wrong password'
PASSWORD_FAIL = %W(#{NO_SAVED_PASSWORD} #{WRONG_PASSWORD})
COURSE_HASH_INFO = {
  'id' => Integer, 'name' => String, 'course_code' => String
}
POSSIBLE_DATA = %w(
  activity users assignments discussion_topics
  student_summaries enrollments quizzes
)
ONE_SECOND = 1

def app
  CanvasVisualizationAPI
end

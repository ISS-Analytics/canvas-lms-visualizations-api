require_relative 'spec_helper'

COURSE_HASH_INFO = {
  'id' => Integer, 'name' => String, 'course_code' => String
}
HTTP_AUTHORIZATION = 'AUTHORIZATION'
TOKEN = "Bearer #{ENV['CANVAS_TOKEN']}"
POSSIBLE_DATA = %w(
  activity users assignments discussion_topics
  student_summaries enrollments quizzes
)

describe 'Getting the root of the service' do
  it 'should return ok' do
    get '/'
    last_response.must_be :ok?
  end

  it 'should return ok' do
    get '/api/v1'
    last_response.must_be :ok?
    last_response.body.must_match(/api v/i, /welcome/i)
  end
end

# describe 'Get course list and visit data pages' do
#   course_ids = []
#   before 'should return an array of hashes with specific info' do
#     header HTTP_AUTHORIZATION, TOKEN
#     get '/api/v1/courses'
#     last_response.status.must_equal 200
#     courses = JSON.parse last_response.body
#     courses.must_be_kind_of Array
#     courses.each do |course|
#       course.must_be_kind_of Hash
#       COURSE_HASH_INFO.each { |key, value| course[key].must_be_kind_of value }
#       course_ids << course['id']
#     end
#   end
#
#   it 'should visit at least one course and verify data types' do
#     course_id = course_ids.sample
#     POSSIBLE_DATA.each do |data|
#       header HTTP_AUTHORIZATION, TOKEN
#       get "/api/v1/courses/#{course_id}/#{data}"
#       last_response.status.must_equal 200
#       result = JSON.parse last_response.body
#       [Hash, Array].must_include result.class
#     end
#   end
# end

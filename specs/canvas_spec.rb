require_relative 'spec_helper'

describe 'Get course list and visit data pages' do
  before do
    SaveTeacher.new(EMAIL_ADDRESS).call
    @api_payload = SaveTeacherPassword.new(EMAIL_ADDRESS, PASSWORD).call
    @api_token = "Bearer #{@api_payload}"
    header HTTP_AUTHORIZATION, @api_token
    post "/api/v1/tokens?url=#{CANVAS_URL}&token=#{CANVAS_TOKEN}"
    header HTTP_AUTHORIZATION, @api_token
    get '/api/v1/tokens'
    @access_key = JSON.parse(
      last_response.body)[FIRST_POSITION][ACCESS_KEY_POSITION]
    @course_ids = []
  end

  it 'should:'\
    'should return an array of hashes with specific info;'\
    'should visit at least one course and verify data types' do
    # should return an array of hashes with specific info
    header HTTP_AUTHORIZATION, @api_token
    get "/api/v1/courses?access_key=#{@access_key}"
    last_response.status.must_equal 200
    courses = JSON.parse last_response.body
    courses.must_be_kind_of Array
    courses.each do |course|
      course.must_be_kind_of Hash
      COURSE_HASH_INFO.each { |key, value| course[key].must_be_kind_of value }
      @course_ids << course['id']
    end

    # should visit at least one course and verify data types
    course_id = @course_ids.sample
    POSSIBLE_DATA.each do |data|
      header HTTP_AUTHORIZATION, @api_token
      get "/api/v1/courses/#{course_id}/#{data}?access_key=#{@access_key}"
      last_response.status.must_equal 200
      result = JSON.parse last_response.body
      [Hash, Array].must_include result.class
    end

    # Delete Teacher & Token data
    Teacher.delete_all
    Token.delete_all
  end
end

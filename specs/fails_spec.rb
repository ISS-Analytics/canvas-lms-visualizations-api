require_relative 'spec_helper'

describe 'Fail at all tasks' do
  before 'Save a teacher with tokens' do
    SaveTeacher.new(EMAIL_ADDRESS).call
    @api_payload = SaveTeacherPassword.new(EMAIL_ADDRESS, PASSWORD).call
    @api_token = "Bearer #{@api_payload}"
    one_second_token = DecryptPayload.new(@api_payload).call
    one_second_token = EncryptPayload.new(one_second_token, ONE_SECOND).call
    @one_second_token = "Bearer #{one_second_token}"
    header HTTP_AUTHORIZATION, @api_token
    post "/api/v1/tokens?url=#{CANVAS_URL}&token=#{CANVAS_TOKEN}"
    header HTTP_AUTHORIZATION, @api_token
    get '/api/v1/tokens'
    @access_key = JSON.parse(
      last_response.body)[FIRST_POSITION][ACCESS_KEY_POSITION]
    @course_ids = []
    @list_of_routes = [
      ['get', "/api/v1/verify_password?password=#{PASSWORD}"],
      ['post', "/api/v1/save_password?password=#{PASSWORD}"],
      ['get', '/api/v1/tokens'],
      ['post', "/api/v1/tokens?url=#{CANVAS_URL}&token=#{CANVAS_TOKEN}"],
      ['delete', "/api/v1/token?access_key=#{@access_key}"],
      ['delete', '/api/v1/tokens'],
      ['get', "/api/v1/courses?access_key=#{@access_key}"]
    ]
  end

  it 'should return 400 for bad header format' do
    @list_of_routes.each do |http_method, route|
      header HTTP_AUTHORIZATION, 'BAD_HEADER'
      send(http_method, route)
      last_response.status.must_equal 400
      last_response.body.must_equal 'Wrong token format'
    end

    # Delete Teacher & Token data
    Teacher.delete_all
    Token.delete_all
  end

  it 'should return 401 for bad header' do
    @list_of_routes.each do |http_method, route|
      header HTTP_AUTHORIZATION, 'Bearer BAD_HEADER'
      send(http_method, route)
      last_response.status.must_equal 401
      last_response.body.must_equal 'Not enough or too many segments'
    end

    # Delete Teacher & Token data
    Teacher.delete_all
    Token.delete_all
  end

  it 'should return 401 for bad tokens' do
    sleep 01
    @list_of_routes.each do |http_method, route|
      header HTTP_AUTHORIZATION, @one_second_token
      send(http_method, route)
      last_response.status.must_equal 401
      last_response.body.must_equal 'Signature has expired'
    end

    # Delete Teacher & Token data
    Teacher.delete_all
    Token.delete_all
  end
end

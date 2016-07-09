require_relative 'spec_helper'

describe 'Token handling' do
  before do
    email_token = SaveTeacher.new(EMAIL_ADDRESS).call
    @email_token = "Bearer #{email_token}"
    @api_payload = SaveTeacherPassword.new(EMAIL_ADDRESS, PASSWORD).call
    @api_token = "Bearer #{@api_payload}"
  end

  it 'should:'\
    'return empty list of tokens;'\
    'save a token;'\
    'return saved token;'\
    'delete token;'\
    'return empty list of tokens after deletion;'\
    'create token, delete all tokens' do
    # return empty list of tokens
    header HTTP_AUTHORIZATION, @api_token
    get '/api/v1/tokens'
    result = JSON.parse last_response.body
    result.must_be_kind_of Array
    result.must_equal []

    # save a token
    header HTTP_AUTHORIZATION, @api_token
    post "/api/v1/tokens?url=#{CANVAS_URL}&token=#{CANVAS_TOKEN}"
    last_response.body[-6..-1].must_equal ' saved'

    # return saved token
    header HTTP_AUTHORIZATION, @api_token
    get '/api/v1/tokens'
    result = JSON.parse last_response.body
    result.must_be_kind_of Array
    result = result[FIRST_POSITION]
    result.length.must_equal 3
    result[OBFUSCATED_POSITION][-7..-1].must_equal '*' * 7
    result[URL_POSITION][0..3].must_equal 'http'
    @access_key = result[ACCESS_KEY_POSITION]
    @access_key.must_be_kind_of String

    # delete token
    header HTTP_AUTHORIZATION, @api_token
    delete "/api/v1/token?access_key=#{@access_key}"
    last_response.status.must_equal 200

    # return empty list of tokens after deletion
    header HTTP_AUTHORIZATION, @api_token
    get '/api/v1/tokens'
    result = JSON.parse last_response.body
    result.must_be_kind_of Array
    result.must_equal []

    # create token, delete all tokens
    header HTTP_AUTHORIZATION, @api_token
    post "/api/v1/tokens?url=#{CANVAS_URL}&token=#{CANVAS_TOKEN}"
    header HTTP_AUTHORIZATION, @api_token
    get '/api/v1/tokens'
    result = JSON.parse last_response.body
    result.must_be_kind_of Array
    result.length.must_equal 1
    # deletion of all tokens must be possible with email token only
    header HTTP_AUTHORIZATION, @email_token
    delete '/api/v1/tokens'
    last_response.status.must_equal 200
    header HTTP_AUTHORIZATION, @api_token
    get '/api/v1/tokens'
    result = JSON.parse last_response.body
    result.must_be_kind_of Array
    result.must_equal []

    # Delete Teacher & Token data
    Teacher.delete_all
    Token.delete_all
  end
end

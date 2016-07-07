require_relative 'spec_helper'

EMAIL_ADDRESS = 'james.uanhoro@gmail.com'
PASSWORD = 'password'
RANDOM_TEXT = (0..10).map { (65 + rand(26)).chr }.join
ENCRYPTED_EMAIL = SaveTeacher.new(EMAIL_ADDRESS).call

NO_SAVED_PASSWORD = 'no password found'
WRONG_PASSWORD = 'wrong password'
PASSWORD_FAIL = %W(#{NO_SAVED_PASSWORD} #{WRONG_PASSWORD})
HTTP_AUTHORIZATION = 'AUTHORIZATION'
TOKEN = "Bearer #{ENCRYPTED_EMAIL}"

describe 'Test login routes' do
  it 'should:'\
    'return no password found;'\
    'save password;'\
    'correctly verify password;'\
    'fail on wrong password' do
    # return no password found
    header HTTP_AUTHORIZATION, TOKEN
    get "/api/v1/verify_password?password=#{PASSWORD}"
    last_response.body.must_equal NO_SAVED_PASSWORD

    # save password
    header HTTP_AUTHORIZATION, TOKEN
    post "/api/v1/save_password?password=#{PASSWORD}"
    last_response.status.must_equal 200
    last_response.body.must_be_kind_of String

    # correctly verify password
    header HTTP_AUTHORIZATION, TOKEN
    get "/api/v1/verify_password?password=#{PASSWORD}"
    PASSWORD_FAIL.wont_include last_response.body

    # fail on wrong password
    header HTTP_AUTHORIZATION, TOKEN
    get "/api/v1/verify_password?password=#{RANDOM_TEXT}"
    last_response.body.must_equal WRONG_PASSWORD
  end
end

require_relative 'spec_helper'

describe 'Test login routes' do
  before do
    @random_text = (0..10).map { (65 + rand(26)).chr }.join
    @encrypted_email = SaveTeacher.new(EMAIL_ADDRESS).call
    @token = "Bearer #{@encrypted_email}"
  end

  it 'should:'\
    'return no password found;'\
    'save password;'\
    'correctly verify password;'\
    'fail on wrong password' do
    # return no password found
    header HTTP_AUTHORIZATION, @token
    get "/api/v1/verify_password?password=#{PASSWORD}"
    last_response.body.must_equal NO_SAVED_PASSWORD

    # save password
    header HTTP_AUTHORIZATION, @token
    post "/api/v1/save_password?password=#{PASSWORD}"
    last_response.status.must_equal 200
    last_response.body.must_be_kind_of String

    # correctly verify password
    header HTTP_AUTHORIZATION, @token
    get "/api/v1/verify_password?password=#{PASSWORD}"
    PASSWORD_FAIL.wont_include last_response.body

    # fail on wrong password
    header HTTP_AUTHORIZATION, @token
    get "/api/v1/verify_password?password=#{@random_text}"
    last_response.body.must_equal WRONG_PASSWORD

    # Delete Teacher data
    Teacher.delete_all
  end
end

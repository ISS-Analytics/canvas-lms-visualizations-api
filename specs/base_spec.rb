require_relative 'spec_helper'

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

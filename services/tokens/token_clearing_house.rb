# Token health check on arrival at API
class TokenClearingHouse
  def initialize(auth_token)
    @auth_token = auth_token
  end

  def call
    payload = BearerToken.new(@auth_token)
    return({ code: 400, error: 'invalid token' }) unless payload.valid?
    payload = DecryptPayload.new(payload.bearer_token)
    result = payload.call
    result
  rescue => e
    puts e
  end
end

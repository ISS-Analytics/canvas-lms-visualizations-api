# Token health check on arrival at API
class TokenClearingHouse
  def initialize(auth_token)
    @auth_token = auth_token
  end

  def call
    payload = BearerToken.new(@auth_token)
    fail 400 unless payload.valid?
    payload = DecryptPayload.new(payload.bearer_token)
    result = payload.call
    fail 401 if result.nil?
    result
  rescue => e
    puts e
  end
end

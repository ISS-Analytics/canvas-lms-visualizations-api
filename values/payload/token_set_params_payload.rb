require_relative 'payload'

# Payload for email, token_set, and params
class TokenSetParamsPayload < Payload
  def initialize(email, token_set, params)
    @payload = { email: email, token_set: token_set, params: params }
  end
end

require_relative 'payload'

# Payload for email and token_set
class TokenSetPayload < Payload
  def initialize(email, token_set)
    @payload = { email: email, token_set: token_set }
  end
end

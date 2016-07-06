require_relative 'payload'

# Payload for email, access_key, and token_set
class AccessKeyTokenSetPayload < Payload
  def initialize(email, access_key, token_set)
    @payload = { email: email, access_key: access_key, token_set: token_set }
  end
end

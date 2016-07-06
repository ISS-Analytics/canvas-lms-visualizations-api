require_relative 'payload'

# Payload for email and access_key
class AccessKeyPayload < Payload
  def initialize(email, access_key)
    @payload = { email: email, access_key: access_key }
  end
end

# Payload for email and access_key
class Payload
  def initialize(email)
    @payload = { email: email }
  end

  def payload
    EncryptPayload.new(@payload.to_json).call
  end
end

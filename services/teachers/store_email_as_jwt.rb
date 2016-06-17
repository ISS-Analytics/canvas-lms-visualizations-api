# Object to create teacher payload
class StoreEmailAsJWT
  def initialize(email)
    @email = email
  end

  def call
    payload = { email: @email }
    JWT.encode payload, ENV['MSG_KEY'], 'HS256'
  end
end

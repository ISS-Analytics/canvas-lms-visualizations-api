require 'json'
require 'base64'
require 'rbnacl/libsodium'
require 'jwt'

NONCE_KEY = 'nonce'
TOKEN_KEY = 'encrypted_token'
JWT_DATA = 'data'

# Service object to retrieve Canvas token from bearer tokens.
class DecryptPayload
  def initialize(bearer_token)
    @payload = bearer_token
    @secret_key = Base64.urlsafe_decode64 ENV['SECRET_KEY']
    @hmac_secret = Base64.urlsafe_decode64 ENV['HMAC_SECRET']
  end

  def call
    payload = JWT.decode @payload, @hmac_secret, true, algorithm: 'HS256'
    payload = JSON.parse payload.first[JWT_DATA]
    secret_box = RbNaCl::SecretBox.new(@secret_key)
    nonce = Base64.urlsafe_decode64 payload[NONCE_KEY]
    token = Base64.urlsafe_decode64 payload[TOKEN_KEY]
    secret_box.decrypt(nonce, token)
  rescue JWT::ExpiredSignature => e
    puts e
  end
end

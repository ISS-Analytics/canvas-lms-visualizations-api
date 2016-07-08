require 'json'
require 'base64'
require 'rbnacl/libsodium'
require 'jwt'

NINETY_MINUTES = 1.5 * 60 * 60

# Service object to encrypt payloads meant for the API.
class EncryptPayload
  attr_accessor :token

  def initialize(token)
    @token = token
    @secret_key = Base64.urlsafe_decode64 ENV['SECRET_KEY']
    @hmac_secret = Base64.urlsafe_decode64 ENV['HMAC_SECRET']
  end

  def call
    secret_box = RbNaCl::SecretBox.new(@secret_key)
    nonce = RbNaCl::Random.random_bytes(secret_box.nonce_bytes)
    ciphertext = secret_box.encrypt(nonce, @token)
    ciphertext = Base64.urlsafe_encode64 ciphertext
    nonce = Base64.urlsafe_encode64 nonce
    payload = { encrypted_token: ciphertext, nonce: nonce }.to_json
    payload = { data: payload, exp: expiration_time }
    JWT.encode payload, @hmac_secret, 'HS256'
  end

  def expiration_time
    Time.now.to_i + NINETY_MINUTES
  end
end

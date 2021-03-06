require 'json'
require 'base64'
require 'rbnacl/libsodium'
require 'jwt'

THREE_HOURS = 3 * 60 * 60

# Service object to encrypt payloads meant for the API.
class EncryptPayload
  attr_accessor :token

  def initialize(token, duration = nil)
    @token = token
    @duration = duration
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
  rescue => e
    puts e
  end

  def expiration_time
    return Time.now.to_i + @duration if @duration
    Time.now.to_i + THREE_HOURS
  end
end

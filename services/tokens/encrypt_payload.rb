require 'json'
require 'base64'
require 'rbnacl/libsodium'

# Service object to encrypt payloads meant for the API.
class EncryptPayload
  attr_accessor :token

  def initialize(token)
    @token = token
    @api_public_key = Base64.urlsafe_decode64 ENV['API_PUBLIC_KEY']
    @ui_private_key = Base64.urlsafe_decode64 ENV['UI_PRIVATE_KEY']
  end

  def call
    box = RbNaCl::Box.new(@api_public_key, @ui_private_key)
    nonce = RbNaCl::Random.random_bytes(box.nonce_bytes)
    ciphertext = box.encrypt(nonce, @token)
    ciphertext = Base64.urlsafe_encode64 ciphertext
    nonce = Base64.urlsafe_encode64 nonce
    payload = { encrypted_token: ciphertext, nonce: nonce }.to_json
    Base64.urlsafe_encode64 payload
  end
end

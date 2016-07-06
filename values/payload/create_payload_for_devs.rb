# Object to create payload for devs to use on API
class CreatePayloadForDevs
  def initialize(tokens, email, token_set)
    @tokens = JSON.parse tokens
    @email = email
    @token_set = token_set
  end

  def call
    @tokens.each do |token|
      payload = AccessKeyTokenSetPayload.new(
        @email, token[2], @token_set).payload
      token << payload
    end
    @tokens
  end
end

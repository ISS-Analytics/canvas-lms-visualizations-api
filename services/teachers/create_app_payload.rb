# Object to save user password as session variable
class CreateAppPayload
  include ModelHelper

  def initialize(email, password, tsalt)
    @email = email
    @password = password
    @tsalt = tsalt
  end

  def call
    payload = base_64_encode(
      Teacher.token_key(@password, base_64_decode(@tsalt))
    )
    TokenSetPayload.new(@email, payload).payload
  end
end

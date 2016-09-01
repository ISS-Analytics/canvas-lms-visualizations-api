FIRST_KEY = 0
ERROR = 'errors'
STATUS = 'status'

# Object to check if Canvas token is expired or action is authorized then
# => return error message
class ErrorMessage
  def initialize(result)
    @result = result
  end

  def call
    result = JSON.parse(@result)
    return false unless result.class == Hash
    result.keys[FIRST_KEY] == ERROR ? @result : false
    case result.keys[FIRST_KEY]
    when ERROR then @result
    when STATUS then { ERROR => result[ERROR] }.to_json
    else false
    end
  end
end

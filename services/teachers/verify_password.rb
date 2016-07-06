# Object to verify password provided by user
class VerifyPassword
  def initialize(email, password)
    @current_teacher = Teacher.find_by_email(email)
    @password = password
  end

  def call
    return 'no password found' if @current_teacher.hashed_password.nil?
    teacher = Teacher.authenticate!(@current_teacher.email, @password)
    if teacher.nil? then 'wrong password'
    else CreateAppPayload.new(
      @current_teacher.email, @password, teacher.token_salt).call
    end
  end
end

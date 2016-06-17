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
    else SavePasswordToJWT.new(@password, teacher.token_salt).call
    end
  end
end

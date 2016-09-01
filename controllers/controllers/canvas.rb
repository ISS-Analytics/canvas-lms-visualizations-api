# Visualizations for Canvas LMS Classes: Interaction with Canvas
class CanvasVisualizationAPI < Sinatra::Base
  get_course_list = lambda do
    payload = TokenClearingHouse.new(env['HTTP_AUTHORIZATION']).call
    halt(*payload.values) if payload.class == Hash
    payload = JSON.parse payload
    email = payload['email']
    access_key = params['access_key']
    token_set = payload['token_set']
    token = YouShallNotPass.new(email, access_key).call
    return 403 unless token
    params_for_api = ParamsForCanvasApi.new(
      token.canvas_api(token_set), token.canvas_token(token_set)
    )
    halt 400 unless params_for_api.valid?
    courses = GetCoursesFromCanvas.new(params_for_api.canvas_api,
                                       params_for_api.canvas_token)
    courses.call
  end

  go_to_api_with_request = lambda do
    payload = TokenClearingHouse.new(env['HTTP_AUTHORIZATION']).call
    halt(*payload.values) if payload.class == Hash
    payload = JSON.parse payload
    email = payload['email']
    access_key = params['access_key']
    token_set = payload['token_set']
    token = YouShallNotPass.new(email, access_key).call
    return 403 unless token
    params_for_api = ParamsForCanvasApi.new(
      token.canvas_api(token_set), token.canvas_token(token_set),
      params['course_id'], params['data']
    )
    halt 400 unless params_for_api.valid?
    result =
    case params['data']
    when 'assignments', 'student_summaries', 'activity' then
      GetCourseAnalyticsFromCanvas.new(params_for_api)
    when 'quizzes' then GetQuizzesFromCanvas.new(params_for_api)
    when 'users' then GetUserLevelDataFromCanvas.new(params_for_api)
    when 'enrollments' then GetCourseInfoFromCanvas.new(params_for_api)
    when 'discussion_topics' then GetDiscussionsFromCanvas.new(params_for_api)
    end.call
    error_message = ErrorMessage.new(result).call
    return error_message if error_message
    result = VisualizationTraffic.new(params['data'], result)
    result.call
  end

  # API Routes
  get '/api/v1/courses/?', &get_course_list
  get '/api/v1/courses/:course_id/:data/?', &go_to_api_with_request
end

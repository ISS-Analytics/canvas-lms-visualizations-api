# Visualizations for Canvas LMS Classes: Interaction with Canvas
class CanvasVisualizationAPI < Sinatra::Base
  get_course_list = lambda do
    payload = BearerToken.new(env['HTTP_AUTHORIZATION'])
    halt 400 unless payload.valid?
    payload = DecryptPayload.new(payload.bearer_token)
    payload = begin payload.call
    rescue => e
      logger.error e
      halt 401
    end
    payload = JSON.parse payload
    email = payload['email']
    access_key = payload['access_key']
    token_set = payload['token_set']
    token = YouShallNotPass.new(email, access_key).call
    return 401 unless token
    params_for_api = ParamsForCanvasApi.new(
      token.canvas_api(token_set), token.canvas_token(token_set)
    )
    halt 400 unless params_for_api.valid?
    courses = GetCoursesFromCanvas.new(params_for_api.canvas_api,
                                       params_for_api.canvas_token)
    courses.call
  end

  go_to_api_with_request = lambda do
    payload = BearerToken.new(env['HTTP_AUTHORIZATION'])
    halt 400 unless payload.valid?
    payload = DecryptPayload.new(payload.bearer_token)
    payload = begin payload.call
    rescue => e
      logger.error e
      halt 401
    end
    payload = JSON.parse payload
    email = payload['email']
    access_key = payload['access_key']
    token_set = payload['token_set']
    token = YouShallNotPass.new(email, access_key).call
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
    end
    result = VisualizationTraffic.new(params['data'], result.call)
    result.call
  end

  # API Routes
  get '/api/v1/courses/?', &get_course_list
  get '/api/v1/courses/:course_id/:data/?', &go_to_api_with_request
end

# Visualizations for Canvas LMS Classes: Tokens
class CanvasVisualizationAPI < Sinatra::Base
  get_tokens = lambda do
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
    token_set = payload['token_set']
    ListTokens.new(email, token_set).call
  end

  post_tokens = lambda do
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
    token_set = payload['token_set']
    SaveToken.new(email, token_set, params).call
  end

  delete_a_token = lambda do
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
    access_key = params['access_key']
    token = YouShallNotPass.new(email, access_key).call
    return 401 unless token
    200 if DeleteToken.new(token).call
  end

  delete_tokens = lambda do
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
    200 if DeleteAllTokens.new(email).call
  end

  # API Routes
  get '/api/v1/tokens', &get_tokens
  post '/api/v1/tokens', &post_tokens
  delete '/api/v1/token', &delete_a_token
  delete '/api/v1/tokens', &delete_tokens
end

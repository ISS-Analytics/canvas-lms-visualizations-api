require 'sinatra/base'
require 'config_env'
require 'rack/ssl-enforcer'
require 'httparty'
require 'ap'
require 'concurrent'
require 'rbnacl/libsodium'
require 'json'
require 'jwt'

configure :development, :test do
  require 'hirb'
  Hirb.enable
  absolute_path = File.absolute_path './config/config_env.rb'
  ConfigEnv.path_to_config(absolute_path)
end

# Visualizations for Canvas LMS Classes
class CanvasVisualizationAPI < Sinatra::Base
  enable :logging
  use Rack::MethodOverride

  configure :production do
    use Rack::SslEnforcer
    set :session_secret, ENV['MSG_KEY']
  end

  api_get_root = lambda do
    "Welcome to our API v1. Here's <a "\
    'href="https://github.com/ISS-Analytics/canvas-lms-visualizations-api">'\
    'our github homepage</a>.'
  end

  ['/', '/api/v1/?'].each { |path| get path, &api_get_root }
end

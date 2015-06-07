require 'pg'
require 'pry'
require 'sinatra/base'
require 'sinatra/reloader'
require 'redcarpet'

require_relative './app'
use Rack::MethodOverride

run App::Server
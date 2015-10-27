$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "aliyun_open_search"
require "pry"
require 'net/http'
# load config/appliction.yml to ENV
require "figaro"
Figaro.application = Figaro::Application.new(
  environment: "test", path: "config/application.yml"
)
Figaro.load

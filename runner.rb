# splitting this runner code into a separate file will allow your tests to run without starting the server
require './lib/working_request_server'

trial = HTTPServer.new
trial.start

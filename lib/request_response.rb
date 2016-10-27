require 'socket'
require "faraday"
require "pry"
require "./server_response_parsing.rb"
require "./request_parsing.rb"

class HTTPServer
  attr_reader :client, :counter, :request_lines, :tcp_server

  def initialize
    @tcp_server = TCPServer.new(9292)
    @counter = 0
    @hello_counter = 0
  end

  def start
    loop do
      @client = tcp_server.accept
      @counter += 1
      puts "Ready for a request"

      request = RequestParsing.new
      request_lines = request.process_request(client)
      hello_counter = if request_lines["Path"].include?("hello")
        @hello_counter += 1
      end
      response = ServerResponseParsing.new
      trial_response = response.send_response_by_path(client, request_lines)
      client.puts trial_response
      if counter == 5
        close_client
      end
    end
  end

  def close_client
    tcp_server.close
    puts "Session complete, EXCITING."
  end

  
end

trial = HTTPServer.new
trial.start


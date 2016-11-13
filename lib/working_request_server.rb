require 'socket'
require 'faraday'
require 'pry'
require './lib/word_search'
# require './lib/json_class'
require './lib/game_path'
require './lib/server_response'
# require './lib/parsing_class'

class HTTPServer
  attr_reader   :client, 
                :counter, 
                :request_lines, 
                :tcp_server, 
                :hello_counter,
                :game 

  def initialize
    @tcp_server = TCPServer.new(9292)
    @hello_counter = 0
    @counter = 0
  end

  def start
    loop do
      @client = tcp_server.accept
      puts "Ready for a request"
      gets_lines
      increment_counters
      server_response = ServerResponse.new(client, request_lines, hello_counter, counter)
      start_game?
      output = server_response.response_by_path(request_lines)
      game_guess(request_lines, client) if game 
      output = game.send_response if request_lines[0].include?("game")
      client.puts server_response.write_header(output)
      client.puts output
      close_client
    end
  end

  def gets_lines
    @request_lines = []
    while line = @client.gets and !line.chomp.empty?
      @request_lines << line.chomp
    end
  end

  def increment_counters
    if client && request_lines[0].include?("hello")
      @hello_counter += 1
    else
      @counter += 1
    end
  end

  def start_game?
    @game = Game.new if @request_lines[0].include?("start_game")
  end

  def game_guess(request_lines, client)
    if @request_lines[0].include?("game") && @request_lines[0].include?("POST")
      length = content_length(request_lines)
      number = client.read(length) 
      game.guesser(number.split(/=/)[-1].to_i)
      redirect_response(client)
    end
  end

  def content_length(request_lines)
    content_length = request_lines.find {|line| line.include?('Content-Length')}
    content_length.split(':')[-1].to_i
  end

  def redirect_response(client)
    header = ['HTTP/1.1 301 Moved Permanently',
              'location: http://localhost:9292/game',
              "date: #{request_timestamp}",
              "server: ruby",
              "content-type: text/html; charset=iso-8859-1\r\n\r\n"].join("\r\n")
    client.puts header 
  end

  def close_client
    if request_lines[0].include?("shutdown")
      tcp_server.close
    end
  end
  
end

trial = HTTPServer.new
trial.start


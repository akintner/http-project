require 'socket'
require 'faraday'
require 'pry'
require './word_search'
require './json_class'
require './game_path'

class HTTPServer
  attr_reader   :client, 
                :counter, 
                :request_lines, 
                :tcp_server, 
                :hello_counter, 
                :close_client

  def initialize
    @tcp_server = TCPServer.new(9292)
    @counter = 0
    @hello_counter = 0
  end

  def start
    loop do
      @client = tcp_server.accept
      puts "Ready for a request"
      gets_lines
      increment_counters
      server_response(request_lines)
    end
  end

  def gets_lines
    @request_lines = []
    while line = @client.gets and !line.chomp.empty?
        @request_lines << line.chomp
    end
  end

  def close_client
    tcp_server.close
  end

  def increment_counters
      if @client && request_lines[0].include?("hello")
        @hello_counter += 1
      else
        @counter += 1
      end
  end

  def server_response(request_lines)
    response = "<pre>" +"<html><body>Verb: #{request_lines[0].split[0]}<br>Path: #{request_lines[0].split[1]}<br>Protocol: #{request_lines[0].split[2]}<br>#{request_lines[1]}<br>#{request_lines[2]}<br>#{request_lines[3]}<br>#{request_lines[4]}<br>#{request_lines[5]}<br>#{request_lines[6]}<br>#{request_lines[7]}<br>#{request_lines[8]}"+"</pre>"
    if request_lines[0].include?("hello")
      output = "<html><head><h1>Request Info</h1></head><body>#{response}<h1>HELLO WORLD<br>#{hello_counter}</h1></body></html>"
    elsif request_lines[0].include?("datetime")
      output = "<html><head><h1>Request Info</h1></head><body>#{response}<h1>date: #{Time.now.strftime('%H:%M:%S on %a, %e %b, %Y')}</h1></body></html>"
    elsif request_lines[0].include?("shutdown")
      output = "<html><head><h1>Request Info</h1></head><body>#{response}<h1>Total Requests: #{counter}</h1></body>#{close_client}</html>" 
    elsif request_lines[0].include?("word_search?parameter=")
      if request_lines[0].include?("json")
        new_json_request = JSONrequest.new
      else
        output = word_search_response(request_lines[0].split[1].split("?")[1].split("=")[1])
      end
    elsif request_lines[0].include?("god")
      output = "<pre><head><h1>Request Info</h1></head><body><h2>THE END IS NIGH, REPENT SINNERS<br>date: #{Time.now.strftime('%H:%M:%S on %a, %e %b, %Y')}<br><img src= 'https://malialitman.files.wordpress.com/2014/06/funny-dog-one.jpg'></h2></body></pre>"
    elsif request_lines[0].include?("game")
      new_game = Game.new
      new_game.start_game(client)
    else
      output = "<html><head><h1>Request Info</h1></head><body>#{response}<h2>AMY DID THIS</h2></body></html>"
    end

    headers = ["http/1.1 200 ok",
          "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
          "server: ruby",
          "content-type: text/html; charset=iso-8859-1",
          "content-length: #{output.length}\r\n\r\n"].join("\r\n")
    client.puts headers
    client.puts output

    puts ["Wrote this response:", headers, output].join("\n")
  end

  def word_search_response(word)
    word_search = WordSearch.new
    if word_search.valid_word?(word)
      "<pre>#{word.upcase} is a known word</pre>"
    else
      "<pre>#{word.upcase} is not a known word</pre>"
    end
  end

  # def post_guess
    # some stuff here
  # end

  # def start_new_game
  #   loop do
  #     @client = tcp_server.accept
  #     puts "Ready for a guessing game!"
  #     post_guess
  #   end
  # end
  
end

trial = HTTPServer.new
trial.start


require "socket"
require "pry"
require "./lib/word_search"
require "./lib/game_path"

class ServerResponse

  attr_reader :output, :request_lines, :client, :request_lines, :header, :response

  def initialize(client, request_lines, hello_counter, counter)
    @counter = counter
    @hello_counter = hello_counter
    @request_lines = request_lines
  end

  def write_response(path_file)
    response = "#{request_lines.join("<br>")}"
    output = "<html><head></head><body><p>#{response}</p><h1>#{path_file}</h1></body></html>"
  end

  def write_header(output)
    headers = ["http/1.1 200 ok",
                "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
                "server: ruby",
                "content-type: text/html; charset=iso-8859-1",
                "content-length: #{output.length}\r\n\r\n"].join("\r\n")
  end

  def response_by_path(request_lines)
    if request_lines[0].include?("hello")
      write_response("Hello, World! #{@hello_counter}")
    elsif request_lines[0].include?("datetime")
      write_response("#{Time.now.strftime('%l:%M%p')} on #{Time.now.strftime('%A, %B %d, %Y')}")
    elsif request_lines[0].include?("shutdown")
      write_response("Total Requests from Server: #{@counter}")
    elsif request_lines[0].include?("word_search")
      if request_lines[0].include?("json")
        new_json_request = JSONrequest.new #never got this working
      else
        word_search_response(request_lines[0].split[1].split("?")[1].split("=")[1])
      end
    elsif request_lines[0].include?("")
      write_response ("")
    elsif request_lines[0].include?("god")
      god_response
    elsif request_lines[0].include?("start_game")
      write_response("Good Luck!")
    elsif request_lines[0].include?("game")
      write_response("Playing Number Guessing Game")
    else
      "Invalid Path, please try again."
    end
  end

  def word_search_response(word)
    word_search = WordSearch.new
    if word_search.valid_word?(word)
      "<pre>#{word.upcase} is a known word</pre>"
    else
      "<pre>#{word.upcase} is not a known word</pre>"
    end
  end

  def god_response
    "<pre><head><h1>Request Info</h1></head><body><h2>THE END IS NIGH, REPENT SINNERS<br>date: #{Time.now.strftime('%H:%M:%S on %a, %e %b, %Y')}<br><img src= 'https://malialitman.files.wordpress.com/2014/06/funny-dog-one.jpg'></h2></body></pre>"
  end
  
end
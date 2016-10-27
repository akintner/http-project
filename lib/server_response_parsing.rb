require "socket"
require "pry"
require "./word_search"

class ServerResponseParsing

  attr_reader :output, :request_lines, :counter
  attr_accessor :response, :hello_counter

  def response_by_path(request_lines)
    if request_lines["Path"].include?("hello")
      hello_response
    elsif request_lines["Path"].include?("datetime")
      datetime_response
    elsif request_lines["Path"].include?("shutdown")
      shutdown_response(counter)
    elsif request_lines["Path"].include?("word_search")
      word_search_response(request_lines["Path"].split[1])
    elsif request_lines["Path"].include?("")
      normal_response
    elsif request_lines["Path"].include?("god")
      god_response
    else
      "Invalid Path, please try again."
    end
  end

  def hello_response
    "<pre><head><h1>Request Info</h1></head><body><h2>Hello, World!</h2><br>(#{hello_counter})</pre>"
  end

  def normal_response
    "<pre><head><h1>Request Info</h1></head><body><h2>AMY DID THIS</h2></body></pre>"
  end

  def datetime_response
    "<pre><head><h1>Request Info</h1></head><body><h2>date: #{Time.now.strftime('%H:%M:%S on %a, %e %b, %Y')}</h2></body></pre>"
  end

  def shutdown_response(counter)
    "<pre><h2>Total requests: #{counter}</h2></pre>"
  end

  def word_search_response(word)
    word_search = WordSearch.new
    possible_matches = word_search.possible_matches(word)

    if word_search.valid_word?(word)
      "<pre>#{word.upcase} is a known word</pre>"
    else
      "<pre>#{word.upcase} is not a known word</pre>"
    end
  end

  def god_response
    "<pre><head><h1>Request Info</h1></head><body><h2>THE END IS NIGH, REPENT SINNERS<br>date: #{Time.now.strftime('%H:%M:%S on %a, %e %b, %Y')}<br><img src= 'https://malialitman.files.wordpress.com/2014/06/funny-dog-one.jpg'></h2></body></pre>"
  end

  def output
      "<html><head></head><body>#{response}</body></html>"
  end

  def headers
    ["http/1.1 200 ok",
      "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
      "server: ruby",
      "content-type: text/html; charset=iso-8859-1",
      "content-length: #{output.length}\r\n\r\n"].join("\r\n")
  end

  def send_response(client, response)
    client.puts response
    client.puts headers
    client.puts output
  end

  def send_response_by_path(client, request_lines)
    response = response_by_path(request_lines)
    send_response(client, response)
  end
  
end
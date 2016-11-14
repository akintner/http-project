require './lib/server_response'
require 'minitest/autorun'
require 'minitest/pride'

class ServerResponseTest < Minitest::Test

  attr_reader :basic_path, :request_lines, :basic_header, :requests

  def setup
    @basic_path = "/"
    @requests = 0
    @request_lines = ["Verb: GET",
                                "Path: /",
                                "Protocol: HTTP/1.1",
                                "Host: localhost:9292",
                                "Connection: keep-alive",
                                "Cache-Control: no-cache",
                                "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/53.0.2785.116 Safari/537.36",
                                "Postman-Token: e7c09f0e-dea2-c5cb-b5f4-446d68a44429",
                                "Accept: */*",
                                "Accept-Encoding: gzip, deflate, sdch",
                                "Accept-Language: en-US,en;q=0.8,fr;q=0.6"]
    @basic_header = ["http/1.1 200 ok",
                "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
                "server: ruby",
                "content-type: text/html; charset=iso-8859-1",
                "content-length: 465\r\n\r\n"].join("\r\n")
  end

  def test_it_exists
    sr = ServerResponse.new(basic_path, request_lines, 0, 0)
    assert ServerResponse
  end

  def test_it_can_write_correct_ouput_given_a_path
    sr = ServerResponse.new(basic_path, request_lines, 0, 0)
    result = sr.write_response("")
    assert_equal "<html><head></head><body><p>Verb: GET<br>Path: /<br>Protocol: HTTP/1.1<br>Host: localhost:9292<br>Connection: keep-alive<br>Cache-Control: no-cache<br>User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/53.0.2785.116 Safari/537.36<br>Postman-Token: e7c09f0e-dea2-c5cb-b5f4-446d68a44429<br>Accept: */*<br>Accept-Encoding: gzip, deflate, sdch<br>Accept-Language: en-US,en;q=0.8,fr;q=0.6</p><h1></h1></body></html>", result
  end

  def test_it_can_write_correct_response_given_hello
    sr = ServerResponse.new(basic_path, request_lines, 0, 0)
    result = sr.write_response("Hello, World!")
    assert_equal "<html><head></head><body><p>Verb: GET<br>Path: /<br>Protocol: HTTP/1.1<br>Host: localhost:9292<br>Connection: keep-alive<br>Cache-Control: no-cache<br>User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/53.0.2785.116 Safari/537.36<br>Postman-Token: e7c09f0e-dea2-c5cb-b5f4-446d68a44429<br>Accept: */*<br>Accept-Encoding: gzip, deflate, sdch<br>Accept-Language: en-US,en;q=0.8,fr;q=0.6</p><h1>Hello, World!</h1></body></html>", result
  end

  def test_it_can_write_correct_response_given_datetime
    sr = ServerResponse.new('datetime', request_lines, 0, 0)
    result = sr.write_response("10:17AM on Sunday, Nov 11")
    assert result.include?('Nov')
  end

  def test_it_can_determine_what_to_output
    sr = ServerResponse.new(basic_path, request_lines, 0, 0)
    output = sr.response_by_path(request_lines)
    result = sr.write_header(output)
    assert_equal basic_header, result
  end

  def test_it_can_access_word_search_with_given_path
    sr = ServerResponse.new("/word_search?word=fetch", request_lines, 0, 0)
    result = sr.response_by_path(request_lines)
    assert_equal "<html><head></head><body><p>Verb: GET<br>Path: /<br>Protocol: HTTP/1.1<br>Host: localhost:9292<br>Connection: keep-alive<br>Cache-Control: no-cache<br>User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/53.0.2785.116 Safari/537.36<br>Postman-Token: e7c09f0e-dea2-c5cb-b5f4-446d68a44429<br>Accept: */*<br>Accept-Encoding: gzip, deflate, sdch<br>Accept-Language: en-US,en;q=0.8,fr;q=0.6</p><h1></h1></body></html>", result
  end

  def test_it_returns_correct_response_when_word_is_not_in_dictionary
    sr = ServerResponse.new('/word_search?parameter=zieunt', request_lines, 0, 0)
    result = sr.word_search_response("zieunt")
    assert_equal "<pre>ZIEUNT is not a known word</pre>", result
  end

  def test_it_wishes_player_luck_when_game_is_started
    sr = ServerResponse.new('/start_game', request_lines, 0, 0)
    result = sr.write_response("Good Luck!")
    assert_equal "<html><head></head><body><p>Verb: GET<br>Path: /<br>Protocol: HTTP/1.1<br>Host: localhost:9292<br>Connection: keep-alive<br>Cache-Control: no-cache<br>User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/53.0.2785.116 Safari/537.36<br>Postman-Token: e7c09f0e-dea2-c5cb-b5f4-446d68a44429<br>Accept: */*<br>Accept-Encoding: gzip, deflate, sdch<br>Accept-Language: en-US,en;q=0.8,fr;q=0.6</p><h1>Good Luck!</h1></body></html>", result
  end

  def test_it_can_read_guess_from_parameters
    sr = ServerResponse.new('/game?guess=17', request_lines, 0, 0)
    #get this working and add here
  end
end
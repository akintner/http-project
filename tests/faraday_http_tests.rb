require 'faraday'
require 'minitest/autorun'
require 'minitest/pride'
require './lib/working_request_response'

class HTTPtests < MiniTest::Test

  def test_httpserver_exists
    server = HTTPServer.new
    assert server.counter == 0
  end

  def test_server_runs
    server = HTTPServer.new
    server.start
    response = Faraday.get('http://127.0.0.1:9292/')
    assert_equal 200, response.status
  end

  def test_status_response_hello_path
    response = Faraday.get('http://127.0.0.1:9292/hello')
    assert_equal 200, response.status
  end

  def test_status_response_datetime_path
    response = Faraday.get('http://127.0.0.1:9292/datetime')
    assert_equal 200, response.status
  end

  def test_status_response_word_search_path
    response = Faraday.get('http://127.0.0.1:9292/word_search')
    assert_equal 200, response.status
  end

  def test_status_response_shutdown_path
    skip
    response = Faraday.get('http://127.0.0.1:9292/shutdown')
    assert_equal 200, response.status
  end

  # def test_server_can_change_interact_with_word_search
  # end
end



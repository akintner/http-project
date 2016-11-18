require 'json'
require 'pry'
require 'unirest'
require "./word_search"

class JSONrequest
  attr_reader   :json_request,
                :word

  def initialize
    json_request = Unirest.post "http://httpbin.org/post",
                        headers:{ "Accept" => "application/json" },
                        parameters:{ :word => ""}
    word = ""
    word_search_in_JSON?(word)
  end

  def word_search_in_JSON?(word)
    word_search = WordSearch.new
    possible_matches = word_search.possible_matches(word)
    return true_response(word) if word_search.valid_word?(word) ## Extract the response text from the logic
    false_response(word)
  end

  def true_response(word)
    "{\"word\":\"#{word}\",\"is_word\":true}"
  end

  def false_response(word)
    "{\"word\":\"#{word}\",\"is_word\":false, #{possible_matches}}"
  end

end

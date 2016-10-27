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
    binding.pry
    word = ""
    word_search_in_JSON?(word)
  end

  def word_search_in_JSON?(word)
    word_search = WordSearch.new
    possible_matches = word_search.possible_matches(word)
    if word_search.valid_word?(word)
      "{\"word\":\"#{word}\",\"is_word\":true}"
    else
      "{\"word\":\"#{word}\",\"is_word\":false, #{possible_matches}}"
    end
  end

end

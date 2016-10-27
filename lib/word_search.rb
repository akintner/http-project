class WordSearch

  attr_reader :dictionary

  def initialize
    @dictionary = File.read("/usr/share/dict/words/").downcase.split("\n")
  end

  def valid_word?(word)
    if word
      word = word.downcase
    end
    dictionary.include?(word)
  end

  def possible_matches(word)
    dictionary.keep_if do |dictionary_word|
      dictionary_word.start_with?(word)
    end
  end


end
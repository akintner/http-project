require './lib/word_search'
require 'minitest/autorun'
require 'minitest/emoji'

class WordSearchTest < MiniTest::Test

  attr_reader :word_search

  def setup
    @word_search = WordSearch.new
  end

  def test_it_populates_whole_dictionary
    assert_equal 235886, word_search.dictionary.length
  end

  def test_it_knows_real_words
    assert word_search.valid_word?('pizza')
    assert word_search.valid_word?('knowledge')
    assert word_search.valid_word?('viscous')
  end

  def test_it_refutes_fake_words
    refute word_search.valid_word?('pizera')
  end

  def test_it_can_take_and_parse_real_upper_case_word
    assert word_search.valid_word?('PIZZA')
  end

  def test_it_invalidates_empty_word
    refute word_search.valid_word?(' ')
    refute word_search.valid_word?(nil)
  end

  def test_it_finds_a_possible_match_for_fragment
    assert word_search.possible_matches("pizz").include?("pizza")
    assert word_search.possible_matches("pizz").include?("pizzeria")
  end

end
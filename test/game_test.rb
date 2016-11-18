require './lib/game_path'
require 'minitest/autorun'

class GameTest < Minitest::Test

  attr_reader :game

  def setup
    @game = Game.new
  end

  def test_it_makes_a_random_number_in_provided_range
    result = game.number
    assert (0..100).to_a.include?(result)
  end

  def test_it_can_add_to_guess_counter
    assert_equal 0, game.guesses
    game.guesser(77)
    assert 1, game.guesses
  end

  def test_it_can_compare_guess_to_the_right_number
    game.guesser(97)
    result = game.guess_compare
    assert_equal String, result.class
  end


  def test_it_returns_response
    game.guesser(17)
    assert game.send_response.include?("17")
  end

end

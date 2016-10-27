require "./working_request_response"

class Game

  attr_accessor     :num_guesses, 
                    :game_in_progress, 
                    :correct_number, 
                    :guess_eval, 
                    :last_guess

  def initialize
    @num_guesses = 0
    @game_in_progress = false
    @correct_number = rand(1..100)
    @guess_eval = ""
  end

  def start_game(client)
    @game_in_progress = true
    game = HTTPServer.new
    game.start_new_game
    guess = game.
    process_guess(guess)
  end

  def process_guess(guess)
    eval_guess(guess)
    record_guess
  end

  def end_game 
    @game_in_progress = false
    @correct_number
  end

  def record_guess
    @num_guesses += 1
  end

  def eval_guess(guess)
    @last_guess = guess
    if guess < correct_number
      @guess_eval = "too low"
    elsif guess > correct_number
      @guess_eval = "too high"
    else
      @guess_eval = "correct"
    end
    @guess_eval
  end


  def game_response
    if num_guesses == 0
      "<pre>Good Luck!</pre>"
    else
      "<pre>#{num_guesses} guesses have been taken.\nYour guess was #{last_guess}.  Your guess was #{@guess_eval}.</pre>"
    end
  end

  def output
    "<html><head></head><body>#{response}</body></html>"
  end

  def headers(output)
    ["http/1.1 200 ok",
      "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
      "server: ruby",
      "content-type: text/html; charset=iso-8859-1",
      "content-length: #{output.length}\r\n\r\n"].join("\r\n")
  end

end
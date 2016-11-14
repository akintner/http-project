
class Game

  attr_reader :number, :guess_number
  attr_accessor :guesses

  def initialize
    @guess_number = nil
    @number = rand(0..100)
    @guesses = 0
  end

  def send_response
    response = "Number of guesses: #{guesses}<br>Your guess was:#{guess_number}, which was #{guess_compare}"
    "<html><head>Game Path Engaged</head><body><h1>#{response}</h1></body></html>"
  end

  def guess_compare
    case @guess_number <=> @number
      when 1
        "too high."
      when -1
        "too low."
      when 0
        "correct!"
    end
  end

  def guesser(number)
    @guess_number = number
    @guesses += 1
  end

end
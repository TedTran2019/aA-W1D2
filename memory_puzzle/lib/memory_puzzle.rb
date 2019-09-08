require_relative 'board'
require_relative 'human_player'
require_relative 'computer_player'

# Handles Memory game logic
class MemoryPuzzle
  def initialize(board, player)
    @board = board
    @prev_guess = nil
    @player = player
    raise 'Invalid player!' unless player.is_a?(ComputerPlayer) ||
                                   player.is_a?(HumanPlayer)
  end

  def play
    @board.render
    until game_over?
      make_guess
      @board.render
    end
    puts 'Congratulations, you won!'
  end

  private

  def make_guess
    guess = obtain_guess
    guess.map!(&:to_i)
    @board[guess].reveal
    give_ai_info(guess)
    handle_game_logic(guess)
  end

  def handle_game_logic(guess)
    if @prev_guess.nil?
      @prev_guess = guess
    else
      did_not_match(guess) if @board[guess] != @board[@prev_guess]
      @prev_guess = nil
    end
  end

  def did_not_match(guess)
    @board.render
    @board[guess].hide
    @board[@prev_guess].hide
    sleep(1)
    system('clear')
  end

  def give_ai_info(guess)
    luck = nil
    value = @board[guess].value
    luck = true if !@prev_guess.nil? && @board[guess] == @board[@prev_guess]
    @player.receive_revealed_card(value, guess, luck)
  end

  def obtain_guess
    guess = nil
    until guess
      guess = @player.get_input(@prev_guess)
      guess = nil unless valid_input?(guess)
    end
    guess
  end

  def game_over?
    @board.won?
  end

  def valid_input?(input)
    return false if input.length != 2
    return false unless input.all? { |num| /\A[0-9]*\z/.match(num) }
    return false unless valid_guess?(input)

    true
  end

  def valid_guess?(input)
    y = input[0].to_i
    x = input[1].to_i
    return false if out_of_bounds?(y, x)
    return false if @prev_guess == [y, x] || @board[[y, x]].face_up

    true
  end

  def out_of_bounds?(row, col)
    size = @board.size
    return true if col >= size || col.negative? || row >= size || row.negative?

    false
  end
end

if $PROGRAM_NAME == __FILE__
  b = Board.new
  # p = HumanPlayer.new('Ted', b.size)
  p = ComputerPlayer.new('Ted', b.size)
  MemoryPuzzle.new(b, p).play
end

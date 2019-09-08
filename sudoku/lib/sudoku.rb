require_relative 'board'

# Handles playing the game Sudoku
class Sudoku
  def initialize(file)
    @board = Board.from_file(file)
    play
  end

  def play
    until solved?
      @board.render
      change_value
    end
    winner_prompt
  end

  private

  def change_value
    coors = grab_coors
    value = grab_value
    @board[coors] = value
  end

  def grab_coors
    coors = nil
    until coors
      prompt_for_coors
      coors = gets.chomp.split(',')
      coors = nil unless valid_coors?(coors)
    end
    coors.map!(&:to_i)
  end

  def grab_value
    value = nil
    until value
      prompt_for_value
      value = gets.chomp
      value = nil unless valid_value?(value)
    end
    value.to_i
  end

  def valid_coors?(coors)
    return false unless coors.length == 2 &&
                        coors.all? { |coor| single_digit?(coor) } &&
                        coors.all? { |coor| all_numbers?(coor) }

    y = coors[0].to_i
    x = coors[1].to_i
    return false unless within_bounds(y, x) &&
                        @board[[y, x]].given == false

    true
  end

  def valid_value?(value)
    return false unless single_digit?(value) &&
                        all_numbers?(value) &&
                        '123456789'.include?(value)

    true
  end

  def single_digit?(str)
    str.length == 1
  end

  def all_numbers?(str)
    /\A[0-9]*\z/.match(str)
  end

  def within_bounds(row, col)
    row >= 0 && row < 9 && col >= 0 && col < 9
  end

  def solved?
    @board.solved?
  end

  def winner_prompt
    @board.render
    puts 'Congratulations, you won!'
  end

  def prompt_for_coors
    puts 'Please enter the coordinates of the tile you wish to change, e.g. 2,3'
  end

  def prompt_for_value
    puts 'Please enter the value you wish to change the tile into, e.g. 5'
  end
end

if $PROGRAM_NAME == __FILE__
  puts 'Please put the puzzle txt file into the puzzle folder before\
  proceeding.'
  puts "Enter the puzzle file's name!"
  path = '../puzzles/'
  file_ext = '.txt'
  Sudoku.new(path << gets.chomp << file_ext)
end

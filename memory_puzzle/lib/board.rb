require_relative 'card'

# Handles the logic of the board for the game Memory
class Board
  VALUES = ('a'..'z').to_a.concat(('A'..'Z').to_a)

  attr_reader :size

  def initialize(size = 4)
    @size = size
    check_board
    @board = Array.new(size) { Array.new(size) }
    populate
  end

  def render
    puts '  0 1 2 3 4 5 6 7 8 9 '[0..(size * 2)]
    @board.each_with_index do |row, y|
      row.each_with_index do |card, x|
        print "#{y} " if x.zero?
        print "#{card} "
      end
      print "\n"
    end
  end

  def won?
    @board.all? { |row| row.all?(&:face_up) }
  end

  def reveal(guessed_pos)
    self[guessed_pos].reveal
  end

  def [](indices)
    y, x = indices
    @board[y][x]
  end

  def []=(indices, value)
    y, x = indices
    @board[y][x] = value
  end

  private

  def check_board
    raise 'Board size must be an even number!' unless @size.even?
    raise 'Board size maximum is 10!' if @size > 10
    raise 'Board size minimum is 2!' if @size < 2
  end

  def populate
    board_elements = (@size * @size) / 2
    chosen_values = (VALUES[0...board_elements] * 2).shuffle
    @board.each_with_index do |row, y|
      row.each_with_index do |_column, x|
        self[[y, x]] = Card.new(chosen_values.pop)
      end
    end
  end
end

require_relative 'tile'

# Handles the board for the game Sudoku
class Board
  SOLVED = [1, 2, 3, 4, 5, 6, 7, 8, 9].freeze

  def self.from_file(file)
    grid = []
    idx_rows = 0
    File.foreach(file).with_index do |line, y|
      line = line.chomp
      check_valid_line(line)
      row = []
      idx_rows = y
      line.each_char { |value| row << Tile.new(value.to_i) }
      grid << row
    end
    col_and_box_valid?(idx_rows, grid)
    new(grid)
  end

  def self.check_valid_line(line)
    raise '9 values per row!' if line.length != 9
    raise 'Numbers only!' unless /\A[0-9]*\z/.match(line)
    raise 'No duplicates for given values per row!' if row_duplicates?(line)
  end

  def self.row_duplicates?(line)
    dict = Hash.new(0)
    line.each_char { |value| dict[value] += 1 }
    dict.each { |k, v| return true if v > 1 && k != '0' }
    false
  end

  def self.col_and_box_valid?(idx_rows, grid)
    raise '9 rows!' unless idx_rows == 8
    raise 'No duplicate values per column' if col_duplicates?(grid)
    raise 'No duplicate values per box' if box_duplicates?(grid)
  end

  def self.col_duplicates?(grid)
    (0...9).each do |x|
      dict = Hash.new(0)
      (0...9).each do |y|
        value = grid[y][x].value
        dict[value] += 1
      end
      dict.each { |k, v| return true if v > 1 && k != 0 }
    end
    false
  end

  def self.box_duplicates?(grid)
    y = 0
    until y == 9
      x = 0
      until x == 9
        dict = Hash.new(0)
        (y...y + 3).each do |row|
          (x...x + 3).each { |col| dict[grid[row][col].value] += 1 }
        end
        dict.each { |k, v| return true if v > 1 && k != 0 }
        x += 3
      end
      y += 3
    end
    false
  end

  private_class_method :check_valid_line, :row_duplicates?, :col_duplicates?,
                       :col_and_box_valid?, :box_duplicates?, :new

  def initialize(grid)
    @grid = grid
  end

  def [](indices)
    y, x = indices
    @grid[y][x]
  end

  def []=(indices, new_value)
    y, x = indices
    @grid[y][x].value = new_value
  end

  def render
    @grid.each do |row|
      row.each do |tile|
        print "#{tile} "
      end
      print "\n"
    end
  end

  def solved?
    row_solved? && col_solved? && box_solved?
  end

  private

  def row_solved?
    @grid.all? do |row|
      values = []
      row.each { |tile| values << tile.value }
      values.sort == SOLVED
    end
  end

  def col_solved?
    (0...9).each do |x|
      values = []
      (0...9).each do |y|
        values << @grid[y][x].value
      end
      return false unless values.sort == SOLVED
    end
    true
  end

  def box_solved?
    y = 0
    until y == 9
      x = 0
      until x == 9
        box = []
        (y...y + 3).each do |row|
          (x...x + 3).each { |col| box << @grid[row][col].value }
        end
        return false unless box.sort == SOLVED

        x += 3
      end
      y += 3
    end
    true
  end
end

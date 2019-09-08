require 'colorize'

# Handles individual tiles for the game Sudoku
class Tile
  attr_reader :value, :given

  def initialize(value)
    @value = value
    @given = value.zero? ? false : true
  end

  def to_s
    @given ? @value.to_s.colorize(:red) : @value.to_s
  end

  def value=(new_value)
    if @given
      false
    else
      @value = new_value
      true
    end
  end
end

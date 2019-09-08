# Handle human player interaction in the game MemoryPuzzle
class HumanPlayer
  def initialize(name, size)
    @name = name
    @size = size
  end

  def get_input(*)
    prompt
    gets.chomp.split(',')
  end

  def receive_revealed_card(*); end

  private

  def prompt
    puts "Please enter the position of the card you'd like to flip (e.g.,'2,3')"
  end
end

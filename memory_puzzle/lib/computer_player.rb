# Handles logic for a computer to automatically play the game Memory
class ComputerPlayer
  def initialize(name, size)
    @name = name
    @known_cards = Hash.new { |h, k| h[k] = [] }
    @size = size
    @valid_guesses = create_valid_moves
    @matches = {}
  end

  def get_input(prev_guess)
    prompt
    match = pick_match
    if match.nil?
      input = pick_unknown
    elsif prev_guess.nil?
      input = match[0].map(&:to_s)
    else
      @matches[match] = false
      input = grab_valid_match(match, prev_guess).map(&:to_s)
    end
    puts input
    input
  end

  def receive_revealed_card(value, guess, luck)
    @known_cards[value] << guess if @known_cards[value].length != 2
    @known_cards.each do |_v, matched|
      if matched.length > 1 && @matches[matched] != false
        @matches[matched] = true
        @matches[matched] = false if luck
      end
    end
  end

  private

  def prompt
    puts "Please enter the position of the card you'd like to flip (e.g.,'2,3')"
  end

  def create_valid_moves
    valid_moves = []
    (0...@size).each do |y|
      (0...@size).each { |x| valid_moves << [y.to_s, x.to_s] }
    end
    valid_moves
  end

  def pick_match
    @matches.each { |k, v| return k if v == true }
    nil
  end

  def grab_valid_match(match, prev_guess)
    match.each { |coor| return coor if coor != prev_guess }
    nil
  end

  def pick_unknown
    @valid_guesses.pop
  end
end

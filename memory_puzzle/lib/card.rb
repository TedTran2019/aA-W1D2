# Handling individual card object for the game Memory
class Card
  attr_reader :value, :face_up

  def initialize(value)
    @value = value
    @face_up = false
  end

  def hide
    @face_up = false
  end

  def reveal
    @face_up = true
  end

  def to_s
    face_up ? value : '_'
  end

  def ==(other)
    value == other.value
  end
end

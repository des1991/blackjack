class Card
  SUITS = %w[♠ ♣ ♥ ♦].freeze
  NUMBERS = (2..10).to_a
  PICTURES = %w[J Q K A].freeze

  attr_reader :rank, :suit, :points

  def initialize(rank, suit, points)
    @rank = rank
    @suit = suit
    @points = points
  end

  def to_s
    "#{rank}#{suit}"
  end
end

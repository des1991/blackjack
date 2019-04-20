class Deck
  attr_reader :cards

  def initialize
    @cards = []
    init_cards
  end

  def deal!
    @cards.shift
  end

  def shuffle
    init_cards
  end

  private

  def init_cards
    numbers = (2..10).to_a
    pictures = %w(J Q K A)
    suits = %w(♠ ♣ ♥ ♦)

    suits.each do |suit|
      numbers.each { |rank| @cards << Card.new(rank, suit, rank) }
      pictures.each do |rank|
        points = rank == "A" ? [1, 11] : 10

        cards << Card.new(rank, suit, points)
      end
    end

    @cards.shuffle!
  end
end

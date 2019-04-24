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
    Card.const_get(:SUITS).each do |suit|
      Card.const_get(:NUMBERS).each do |rank|
        @cards << Card.new(rank, suit, rank)
      end
      Card.const_get(:PICTURES).each do |rank|
        points = rank == 'A' ? [1, 11] : 10

        cards << Card.new(rank, suit, points)
      end
    end

    @cards.shuffle!
  end
end

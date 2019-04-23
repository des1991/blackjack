class Hand
  attr_reader :cards, :points

  def initialize
    discard
  end

  def discard
    @cards = []
    @points = 0
  end

  def take_cards(deck, amount=1)
    amount.times { @cards << deck.deal! }

    sum_points
  end

  def sum_points
    points = 0

    @cards.each do |card|
      unless card.points.kind_of?(Array)
        points += card.points
      end
    end

    @cards.each do |card|
      if card.points.kind_of?(Array)
        if points + card.points.last > 21
          points += card.points.first
        else
          points += card.points.last
        end
      end
    end

    @points = points
  end
end

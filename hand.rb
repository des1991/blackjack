class Hand
  attr_reader :cards, :points

  def initialize
    discard
  end

  def discard
    @cards = []
    @points = 0
  end

  def take_cards(deck, amount = 1)
    amount.times { @cards << deck.deal! }

    sum_points
  end

  def sum_points
    points = 0

    @cards.each do |card|
      points += card.points unless card.points.is_a?(Array)
    end

    @cards.each do |card|
      next unless card.points.is_a?(Array)

      points += choose_point_for_ace(points, card.points)
    end

    @points = points
  end
  
  def choose_point_for_ace(points, ace_points)
    if points + ace_points.last > 21
      ace_points.first
    else
      ace_points.last
    end
  end
end

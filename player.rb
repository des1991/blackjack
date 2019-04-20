require_relative 'interface'

class Player
  include Interface

  attr_reader :name, :bank, :cards, :points

  def initialize(name)
    @name = name
    @bank = 100
    @cards = []
    @points = 0
  end

  def bet(amount)
    @bank -= amount
  end

  def win(amount)
    @bank += amount
  end

  def take_card(amount=1, deck)
    amount.times { @cards << deck.deal! }
    calc_points
  end

  def discard
    @cards = []
  end

  def hand(mode=:open)
    puts "#{@name} (#{@bank}$):"

    if mode == :open
      puts @cards.join(" + ")
      puts "Points: #{@points}"
    else
      @cards.length.times do |count|
        print " + " if count > 0
        print "**"
      end
      print "\n"

      puts_separator
    end
  end

  protected

  def calc_points
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

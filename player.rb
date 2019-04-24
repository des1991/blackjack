require_relative 'hand'

class Player
  attr_reader :name, :bank, :hand

  def initialize(name)
    @name = name
    @bank = 100
    @hand = Hand.new
  end

  def bet(amount)
    @bank -= amount
  end

  def win(amount)
    @bank += amount
  end

  def money?
    return true if @bank > 0

    false
  end
end

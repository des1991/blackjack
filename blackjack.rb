require_relative 'deck'
require_relative 'card'
require_relative 'player'
require_relative 'dealer'
require_relative 'interface'

class Blackjack
  include Interface

  PLAYER_CHOICE = [
    { title: "Skip turn", answer: 1, method: :skip },
    { title: "Take card", answer: 2, method: :take_card },
    { title: "Open cards", answer: 3, method: :open_cards }
  ]

  attr_accessor :player, :dealer, :deck

  def initialize
    @bank = 0
  end

  def run
    start_game
    game
  end

  def start_game
    puts "Game starts"
    self.player = create_player
    self.dealer = Dealer.new
    self.deck = Deck.new
  end

  def game
    loop do
      deck.shuffle

      player.take_card(2, deck)
      dealer.take_card(2, deck)

      bet(10)
      
      show_hands

      player_choice

      break unless restart? && players_has_money?
    end
  end

  private

  def create_player
    print 'Name: '
    Player.new(gets.chomp)
  end

  def bet(amount)
    player.bet(amount)
    dealer.bet(amount)

    @bank = amount * 2

    puts_separator
    puts "Bet from #{player.name}: #{amount}$"
    puts "Bet from #{dealer.name}: #{amount}$"
    puts "Game bank: #{@bank}$"
  end

  def show_hands(mode=nil)
    puts_separator

    player.hand

    puts_separator("-", 20)

    dealer.hand(mode)
  end

  def player_choice
    loop do
      PLAYER_CHOICE.each do |choice|
        puts "#{choice[:answer]} - #{choice[:title]}"
      end

      print "Select action: "
      answer = gets.to_i
      selected = PLAYER_CHOICE.find { |item| answer == item[:answer] }

      next unless selected

      self.send(selected[:method])

      break
    end
  end

  def skip
    dealer_choice
  end

  def take_card
    player.take_card(deck)

    dealer_choice
  end

  def open_cards
    show_hands(:open)

    sum_result
  end

  def dealer_choice
    puts_separator

    if dealer.points >= 17 || dealer.cards.length > 2
      puts "-#{dealer.name} skipped a turn"
    else
      dealer.take_card(deck)

      puts "-#{dealer.name} takes a card"
    end

    if player.cards.length > 2
      open_cards
    else
      show_hands

      player_choice
    end
  end

  def sum_result
    if (player.points > 21)
      win(:dealer)
    elsif (dealer.points > 21)
      win(:player)
    elsif (player.points == dealer.points)
      win(:no_one)
    elsif (player.points > dealer.points)
      win(:player)
    else
      win(:dealer)
    end

    puts "#{player.name}'s bank: #{player.bank}$"
    puts "#{dealer.name}'s bank: #{dealer.bank}$"

    player.discard
    dealer.discard
  end

  def win(winner)
    puts_separator

    case winner
      when :player
        player.win(@bank)

        puts "Player won"
      when :dealer
        dealer.win(@bank)

        puts "Dealer won"
      else
        half_bank = @bank / 2

        player.win(half_bank)
        dealer.win(half_bank)

        puts "Draw"
    end

    @bank = 0
  end

  def players_has_money?
    if player.bank > 0 && dealer.bank > 0
      return true
    end

    false
  end

  def restart?
    loop do
      puts_separator
      print "One more time? (Y/n): "
      answer = gets.chomp

      if ["", "Y", "y"].include?(answer)
        return true
      elsif ["N", "n"].include?(answer)
        return false
      end
    end
  end
end

game = Blackjack.new
game.run

require_relative 'deck'
require_relative 'card'
require_relative 'player'
require_relative 'dealer'
require_relative 'interface'

class Blackjack
  attr_accessor :player, :dealer, :players, :deck
  attr_reader :ui

  def initialize(interface)
    @bank = 0
    @ui = interface
    @deck = Deck.new
  end

  def run
    ui.start_game
    init_players
    game
  end

  def game
    loop do
      init_new_game

      player_choice

      break unless ui.restart_game?

      players.each { |player| break unless player.money? }
    end
  end

  private

  def init_players
    self.player = Player.new(ui.ask_name)
    self.dealer = Dealer.new

    self.players = [@player, @dealer]
  end

  def init_new_game
    deck.shuffle

    players.each do |player|
      player.hand.discard
      player.hand.take_cards(deck, 2)
    end

    bet(10)

    ui.show_hands(players)
  end

  def bet(amount)
    players.each { |player| player.bet(amount) }

    @bank = amount * 2

    ui.show_bets(players, amount, @bank)
  end

  def player_choice
    selected = ui.player_choice

    case selected
    when :skip
      dealer_choice
    when :take
      take_card
    when :open
      open_cards
    end
  end

  def take_card
    player.hand.take_cards(deck)

    ui.print_take_card(player)

    dealer_choice
  end

  def open_cards
    ui.show_hands(players, :open)

    sum_result(player.hand.points, dealer.hand.points)

    ui.show_banks(players)

    @bank = 0
  end

  def dealer_choice
    dealer_hand = dealer.hand

    if dealer_hand.points >= 17 || dealer_hand.cards.length > 2
      ui.print_skip_turn(dealer)
    else
      dealer_hand.take_cards(deck)

      ui.print_take_card(dealer)
    end

    choice_route
  end

  def choice_route
    if player.hand.cards.length > 2
      open_cards
    else
      ui.show_hands(players)

      player_choice
    end
  end

  def sum_result(player_points, dealer_points)
    if player_points > 21
      win(dealer)
    elsif dealer_points > 21 || player_points > dealer_points
      win(player)
    elsif player_points == dealer_points
      win(nil)
    else
      win(dealer)
    end
  end

  def win(winner)
    if winner.nil?
      half_bank = @bank / 2

      players.each { |player| player.win(half_bank) }
    else
      winner.win(@bank)
    end

    ui.show_winner(winner)
  end
end

Blackjack.new(Interface.new).run

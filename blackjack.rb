require_relative 'deck'
require_relative 'card'
require_relative 'player'
require_relative 'dealer'
require_relative 'interface'

class Blackjack
  attr_accessor :player, :dealer,:players, :deck
  attr_reader :ui

  def initialize(interface)
    @bank = 0
    @ui = interface
    @deck = Deck.new
  end

  def run
    start_game
    game
  end

  def start_game
    ui.start_game

    init_players
  end

  def game
    loop do
      init_new_game

      player_choice

      break unless restart? && players_has_money?
    end
  end

  private

  def init_players
    player_name = ui.ask_name

    self.player = Player.new(player_name)
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

    sum_result
  end

  def dealer_choice
    if dealer.hand.points >= 17 || dealer.hand.cards.length > 2
      ui.print_skip_turn(dealer)
    else
      dealer.hand.take_cards(deck)

      ui.print_take_card(dealer)
    end

    if player.hand.cards.length > 2
      open_cards
    else
      ui.show_hands(players)

      player_choice
    end
  end

  def sum_result
    if (player.hand.points > 21)
      win(:dealer)
    elsif (dealer.hand.points > 21)
      win(:player)
    elsif (player.hand.points == dealer.hand.points)
      win(:no_one)
    elsif (player.hand.points > dealer.hand.points)
      win(:player)
    else
      win(:dealer)
    end

    ui.show_banks(players)
  end

  def win(winner)
    case winner
      when :player
        player.win(@bank)

        ui.show_winner(player)
      when :dealer
        dealer.win(@bank)

        ui.show_winner(dealer)
      else
        half_bank = @bank / 2

        player.win(half_bank)
        dealer.win(half_bank)

        ui.show_winner(nil)
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
    ui.restart_game?
  end
end

game = Blackjack.new(Interface.new).run

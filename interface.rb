class Interface
  PLAYER_CHOICE = [
    { title: 'Skip turn', answer: 1, action: :skip },
    { title: 'Take card', answer: 2, action: :take },
    { title: 'Open cards', answer: 3, action: :open }
  ].freeze

  def start_game
    puts 'Blackjack'
    puts 'Game starts!'
  end

  def ask_name
    print 'Enter your name: '
    gets.chomp
  end

  def show_bets(players, amount, bank)
    print_separator
    players.each { |player| puts "Bet from #{player.name}: #{amount}$" }
    puts "Game bank: #{bank}$"
  end

  def show_hands(players, mode = nil)
    print_separator

    players.each_with_index do |player, index|
      print_separator('-', 20) if index > 0

      puts "#{player.name} (#{player.bank}$):"

      show_hand(player, mode)
    end
  end

  def show_hand(player, mode)
    player_hand = player.hand

    if mode == :open || !player.is_a?(Dealer)
      puts player_hand.cards.join(' + ') + "\nPoints: #{player_hand.points}"
    else
      player_hand.cards.length.times do |count|
        print count > 0 ? ' + **' : '**'
      end      
      print "\n"
    end
  end

  def show_banks(players)
    players.each { |player| puts "#{player.name}'s bank: #{player.bank}$" }
  end

  def show_winner(winner)
    print_separator

    if winner.nil?
      puts 'Draw!'
    else
      puts "#{winner.name} wins!"
    end
  end

  def player_choice
    print_separator

    loop do
      PLAYER_CHOICE.each do |choice|
        puts "#{choice[:answer]} - #{choice[:title]}"
      end

      answer = select_answer
      selected = PLAYER_CHOICE.find { |item| answer == item[:answer] }

      next unless selected

      return selected[:action]
    end
  end

  def select_answer
    print 'Select action: '
    gets.to_i
  end

  def print_skip_turn(player)
    print_separator
    puts "-#{player.name} skipped a turn"
  end

  def print_take_card(player)
    print_separator
    puts "-#{player.name} takes a card"
  end

  def restart_game?
    loop do
      print_separator
      print 'One more game? (Y/n): '
      answer = gets.chomp

      return true if ['', 'Y', 'y'].include?(answer)
      return false if %w[N n].include?(answer)
    end
  end

  def print_separator(mark = '-', length = 40)
    length.times do
      print mark
    end

    print "\n"
  end
end

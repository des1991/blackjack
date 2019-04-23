class Interface  
  PLAYER_CHOICE = [
    { title: "Skip turn", answer: 1, action: :skip },
    { title: "Take card", answer: 2, action: :take },
    { title: "Open cards", answer: 3, action: :open }
  ]

  def start_game
    puts "Blackjack"
    puts "Game starts!"
  end

  def ask_name
    print "Enter your name: "
    gets.chomp
  end

  def show_bets(players, amount, bank)
    print_separator
    players.each { |player| puts "Bet from #{player.name}: #{amount}$" }
    puts "Game bank: #{bank}$"
  end

  def show_hands(players, mode=nil)
    print_separator

    players.each_with_index do |player, index|
      print_separator("-", 20) if index > 0

      hand = player.hand

      puts "#{player.name} (#{player.bank}$):"

      if mode == :open || !player.is_a?(Dealer)
        puts hand.cards.join(" + ")
        puts "Points: #{hand.points}"
      else
        hand.cards.length.times do |count|
          print " + " if count > 0
          print "**"
        end
        print "\n"
      end
    end
  end

  def show_banks(players)
    players.each { |player| puts "#{player.name}'s bank: #{player.bank}$" }
  end

  def show_winner(winner)
    print_separator

    if winner.nil?
      puts "Draw!"
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

      print "Select action: "
      answer = gets.to_i
      selected = PLAYER_CHOICE.find { |item| answer == item[:answer] }

      next unless selected

      return selected[:action]

      break
    end
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
      print "One more game? (Y/n): "
      answer = gets.chomp

      if ["", "Y", "y"].include?(answer)
        return true
      elsif ["N", "n"].include?(answer)
        return false
      end
    end
  end

  def print_separator(mark='-', length=40)
    length.times do
      print mark
    end

    print "\n"
  end
end

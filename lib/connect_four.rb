class ConnectFour
  attr_reader :current_neighbors, :board, :players, :current_player, :round
  def initialize(first, last)
    @board = create_board
    @players = [first, last]
    @round = 1
    @current_player = switch_player(round)
  end

  def play
    introduction
    ask_player_name
    print_board
    turn_player
    game_over_message
  end

  def turn_player
    loop do
      print_player_turn
      input = get_input
      add(input, current_player)
      update_neighbors(input)
      print_board
      return if over?
      @round += 1
      switch_player(round)
    end
  end

  def create_board
    board = {}
    ("0".."9").to_a.reverse.each do |number|
      ("A".."J").each { |letter| board["#{letter}#{number}"] = nil }
    end
    board
  end

  def add(position, player)
    @board[position] = player.symbol unless taken?(position)
  end

  def ask_player_name
    2.times do |i|
      player_name = i == 0 ? "first player name" : "last player name"
      puts "Please enter #{player_name}"
      @players[i].name = gets.chomp
    end
  end

  def switch_player(count)
    @current_player = count.odd? ? players[0] : players[1]
  end

  def get_input
    puts "Please input position"

    loop  do
      position = gets.chomp.chars
      position[0] = position[0].upcase
      position = position.join
      return position if valid_input?(position) && !taken?(position)

      puts "You entered wrong position!, please enter again."
    end
  end

  def convert_to_number(input)
    return nil if !valid_input?(input)
    input = input.chars

    letters = ("A".."J").to_a
    input[0] = letters.index(input[0]).to_s
    input.join
  end

  def convert_to_key(input)
    input = input.chars
    return nil if invalid?(input)

    letters = ("A".."J").to_a
    input[0] = letters[input[0].to_i]
    input.join
  end

  def valid_input?(input)
    input = input.chars
    return false unless input.length.eql?(2)

    input[0].between?("A","J") and input[1].between?("0","9")
  end

  def taken?(input)
    !@board[input].nil?
  end

  def invalid?(array)
    array.length > 3 or array.any? { |item| !item.between?("0", "9") }
  end

  def update_neighbors(key)
    current = key

    @current_neighbors = (0..7).map do |items|
      index, stop, current_position, temp = items, false, current, []
      3.times do
        current_key = direction(current_position, index)
        invalid = stop || current_key.nil? || !@board[current_key].eql?(@board[current])
        next stop = true if invalid

        current_position = current_key
        temp << current_key
      end
      temp
    end
  end

  def direction(key, index)
    key = convert_to_number(key).chars
    a, b = key[0].to_i, key[1].to_i

    directions = [
      [a-1, b], [a-1, b+1], [a, b+1], [a+1, b+1],
      [a+1, b], [a+1, b-1], [a, b-1], [a-1, b-1]
    ]

    convert_to_key(directions[index].join)
  end

  def node_in_edge
    @current_neighbors.any? { |items| items.length.eql?(3) }
  end

  def node_in_middle
    current_neighbors.each_with_index.any? do |items, index|
      items.length.eql?(1) and current_neighbors[index - 4].length.eql?(2)
    end
  end

  def over?
    won? or draw?
  end

  def won?
    node_in_edge or node_in_middle
  end

  def draw?
    board.all? { |key, value| !value.nil? }
  end

  private
  def introduction
    docs = <<-HEREDOC

      This is a game called Connect four. You will provide with board 10 x 10.
      Letters in bottom and numbers in left side to help when you add color in board

              - - - - - - - - - - - - - - - - - - - -
            9 |   |   |   |   |   |   |   |   |   |   |
              - - - - - - - - - - - - - - - - - - - -
            8 |   |   |   |   |   |   |   |   |   |   |
              - - - - - - - - - - - - - - - - - - - -
            7 |   |   |   |   |   |   |   |   |   |   |
              - - - - - - - - - - - - - - - - - - - -
            6 |   |   |   |   |   |   |   |   |   |   |
              - - - - - - - - - - - - - - - - - - - -
            5 |   |   |   |   |   |   |   |   |   |   |
              - - - - - - - - - - - - - - - - - - - -
            4 |   |   |   |   |   |   |   |   |   |   |
              - - - - - - - - - - - - - - - - - - - -
            3 |   |   |   |   |   |   |   |   |   |   |
              - - - - - - - - - - - - - - - - - - - -
            2 |   |   |   |   |   |   |   |   |   |   |
              - - - - - - - - - - - - - - - - - - - -
            1 |   |   |   |   |   |   |   |   |   |   |
              - - - - - - - - - - - - - - - - - - - -
            0 |   |   |   |   |   |   |   |   |   |   |
              - - - - - - - - - - - - - - - - - - - -
                A   B   C   D   E   F   G   H   I   J

      The winner of game is the one who make 4 places in a row connected first
      It can be horizontal, vertical, or diagonal.

      How to add your color : You can input the coordinate of the board insensitive
      like "A0" or "a0". but you can't wrong input value like "00" or "!A".
      It starts from first player looping until game is over.

      let's get started!

    HEREDOC
    puts docs
  end

  def game_over_message
    winner_message = "Game over!!\nThe winner of this game is #{current_player.name}."
    draw_mesage = "Game over!!\nGame result is draw."
    puts won? ? winner_message : draw_mesage
  end

  def print_player_turn
    puts "#{current_player.name.capitalize} turn"
  end

    def print_board
    display, letters, count = "", "  ", 9
    dashes = "   - - - - - - - - - - - - - - - - - - - -\n"
    ("A".."J").each { |letter| letters += "  #{letter} " }
    @board.each do |key, item|
      position = key.chars
      if position[0] == "A"
        first = "\n#{dashes}#{count} |   |"
        second = "\n#{dashes}#{count} | #{item} |"
        display += item.nil? ? first : second
        count -= 1
        next
      end
      display += item.nil? ? "   |" : " #{item} |"
    end
    puts display
    puts dashes
    puts letters
  end
end

# game = ConnectFour.new
# class Player
#   attr_reader :symbol
#   def initialize(symbol)
#     @symbol = symbol
#   end
# end

# player = Player.new("X")
# ["A0", "B0", "C0", "D0", "E0"].each do |key|
#   game.add(key, player)
# end

# game.print_board
# p game.update_neighbors("D0")
# p game.direction("A0", 4)
